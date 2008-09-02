package Protobuf::Meta::Message;
use Moose;

extends qw(Moose::Meta::Class);

use Protobuf::Attribute::Field::Repeated;
use Protobuf::Attribute::Field::Scalar;
use Protobuf::Decoder;
use Protobuf::Encoder;
use Moose::Util::TypeConstraints;
use Protobuf::Meta::Message;

use namespace::clean -except => 'meta';

has 'descriptor' => (
    isa => "Protobuf::Descriptor",
    is  => "rw",
    #required => 1, # Class::MOP bug
);

# hashref from field number -> Attribute
has 'attribute_by_number' => (
    is => 'rw',
);

sub create_from_descriptor {
    my ( $metaclass, %args ) = @_;

    my $descriptor = $args{descriptor} || die "descriptor is required";

    my $name = delete($args{class}) || $descriptor->name;

    my @attributes = $metaclass->fields_to_attributes(%args, class => $name);

    # For O(1) lookup of field number when decoding...
    my %attribute_by_number;
    foreach my $attr (@attributes) {
        $attribute_by_number{$attr->field->number} = $attr;
    }

    $metaclass->create( $name,
        %args,
        superclasses => ['Protobuf::Message' ],
        attributes   => [
            @attributes,
            # FIXME move _protobuf_extra_fields to base class?
            Moose::Meta::Attribute->interpolate_class_and_new( "_protobuf_extra_fields" => (
                init_arg => undef,
                isa => "ArrayRef",
                lazy => 1,
                default => sub { [] },
            )),
        ],
        methods      => { $metaclass->generate_default_methods(%args, class => $name) },
    );

    # TODO(bradfitz): do this earlier, and pass it to
    # generate_default_methods, so it can be captured by all the
    # methods, so they don't have to do it themselves?
    my $meta = Class::MOP::Class->initialize($name);

    $meta->descriptor($descriptor);
    $meta->attribute_by_number(\%attribute_by_number);

    return $meta;
}

sub generate_default_methods {
    my ( $metaclass, %args ) = @_;

    return (
        new => sub {
            my ($class, %param) = @_;
            return $class->meta->new_object(%param);
        },
        serialize_to_string => sub {
            my $self = shift;

            my $meta = Class::MOP::Class->initialize(ref $self);

            # TODO(nothingmuch): generalize to allow IO
            my $buf = '';
            my $e = Protobuf::Encoder->new;
            my $emit = sub {
                my ($field, $value) = @_;
                $buf .= $e->encode_field( $field->number, $field->type, $value );
            };

            $meta->protobuf_emit($self, $emit);

            my $extra = $meta->protobuf_extra_attribute;

            if ( $extra->has_value($self) ) {
                foreach my $event ( @{ $extra->get_value($self) } ) {
                    $buf .= $e->encode_wire( $event->{fieldnum}, $event->{wire_format}, $event->{value} );
                }
            }

            return $buf;
        },
        parse_from_string => sub {
            die "wrong number of arguments. expected 2." unless @_ == 2;
            my $self = $_[0];
            $self->clear;
            $self->merge_from_string($_[1]);
        },
        clear => sub {
            my $self = shift;
            my $meta = Class::MOP::Class->initialize(ref $self);

            for my $attr ($meta->protobuf_attributes, $meta->protobuf_extra_attribute ) {
                $attr->clear_value($self);
            }
        },
        merge_from_string => sub {
            die "wrong number of arguments. expected 2." unless @_ == 2;
            my $self = $_[0];
            my $iter = Protobuf::Decoder->decode_iterator(\$_[1]);
            $self->_merge_from_decode_iterator($iter);
        },
        _merge_from_decode_iterator => sub {
            die "wrong number of arguments. expected 2." unless @_ == 2;
            my ($self, $iter) = @_;
            my $meta = Class::MOP::Class->initialize(ref $self);
            my $attribute_by_number = $meta->attribute_by_number;

            my @extra;

          EVENT:
            while (my $event = $iter->next) {
                my $fieldnum = $event->{'fieldnum'} or
                    die "assert: expected field number.";

                # skip unknown attributes.
                if ( my $attr = $attribute_by_number->{$fieldnum} ) {
                    my $value;
                    if ($attr->field->is_aggregate) {
                        my $class_name = $attr->field->message_type->class_name;
                        $value = $class_name->new;

                        if ( $event->{'type'} && $event->{'type'} eq "start_group") {
                            # this returns an iterator which tracks nesting depth
                            # and stops at the matching 'end_group'.  it also
                            # keeps advancing the main iterator from which it came.
                            my $groupiter = $iter->subgroup_iterator;
                            $value->_merge_from_decode_iterator($groupiter);
                        } elsif (defined $event->{'value'}) {
                            # an embedded message
                            $value->merge_from_string($event->{'value'});
                        } else {
                            die "internal assert: expected a group or value from parse stream.";
                        }
                    } else { 
                        # We convert values now that we know their real
                        # type (not just their wire type).
                        die "internal assert: expected value in non-aggregate" unless
                        defined $event->{value};
                        $value = Protobuf::Decoder->decode_value($attr, $event->{value});
                    }

                    if ($attr->does('Protobuf::Attribute::Field::Scalar')) {
                        $attr->set_value($self, $value);
                    } else {
                        $attr->push_value($self, $value);
                    }
                } else {
                    push @extra, $event;
                }
            }

            if ( @extra ) {
                push @{ $meta->protobuf_extra_attribute->get_value($self) }, @extra;
            }
        },
    );
}

sub fields_to_attributes {
    my ( $self, %args ) = @_;

    my @fields = @{ $args{descriptor}->fields };

    my @attributes = map {
        my $field = $_;
        Moose::Meta::Attribute->interpolate_class_and_new( $field->name => (
            traits => [ 'Protobuf::Field::' . ( $field->is_repeated ? 'Repeated' : 'Scalar' ) ],
            field => $field,
        ));
    } @fields;
}

sub protobuf_attributes {
    my $self = shift;

    return sort { $a->field->number <=> $b->field->number }
        grep { $_->does("Protobuf::Attribute::Field") }
            $self->compute_all_applicable_attributes;
}

sub protobuf_extra_attribute {
    my $self = shift;

    $self->find_attribute_by_name("_protobuf_extra_fields")
}

sub protobuf_emit {
    my ( $self, $instance, @args ) = @_;

    foreach my $attr ( $self->protobuf_attributes ) {
        $attr->protobuf_emit($instance, @args);
    }
}

__PACKAGE__

__END__
