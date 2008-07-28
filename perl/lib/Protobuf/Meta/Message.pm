package Protobuf::Meta::Message;
use Moose;

extends qw(Moose::Meta::Class);

use Protobuf::Attribute::Field::Repeated;
use Protobuf::Attribute::Field::Scalar;
use Protobuf::Encoder;
use Moose::Util::TypeConstraints;
use Protobuf::Meta::Message;

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

no Moose;

__PACKAGE__

__END__
