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

sub create_from_descriptor {
    my ( $metaclass, %args ) = @_;

    my $descriptor = $args{descriptor} || die "descriptor is required";

    my $name = delete($args{class}) || $descriptor->name;

    $metaclass->create( $name,
        %args,
        superclasses => ['Protobuf::Message' ],
        attributes   => [ $metaclass->fields_to_attributes(%args, class => $name) ],
        methods      => { $metaclass->generate_default_methods(%args, class => $name) },
    );

    my $meta = Class::MOP::Class->initialize($name);

    $meta->descriptor($descriptor);

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

            # TODO(nothingmuch) generalize to allow IO
            my $buf = '';
            my $e = Protobuf::Encoder->new;
            my $emit = sub {
                my ($field, $value) = @_;
                $buf .= $e->encode_field( $field->number, $field->type, $value );
            };

            $meta->protobuf_emit($self, $emit);

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

            # TODO(bradfitz): is the grep really necessary?  I'm
            # concerned that it's unnecessary and just slows this
            # down.
            for my $attr (grep { $_->does("Protobuf::Attribute::Field") }
                          $meta->compute_all_applicable_attributes) {
                $attr->clear_value($self);
            }
        },
        merge_from_string => sub {
            die "wrong number of arguments. expected 2." unless @_ == 2;
            my $self = $_[0];
            my $iter = Protobuf::Decoder->decode_iterator(\$_[1]);
            die "iter = $iter\n";
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

    return sort { $a->field->index <=> $b->field->index }
        grep { $_->does("Protobuf::Attribute::Field") }
            $self->compute_all_applicable_attributes;
}

sub protobuf_emit {
    my ( $self, $instance, @args ) = @_;

    foreach my $attr ( $self->protobuf_attributes ) {
        $attr->protobuf_emit($instance, @args);
    }
}

__PACKAGE__

__END__
