package Protobuf::Attribute::Field::Scalar;
use Moose::Role;

with q(Protobuf::Attribute::Field);

sub _process_options {
    my ( $class, $name, $options ) = @_;

    $options->{reader} = $name;
    $options->{predicate} = "has_$name";
    $options->{predicate} = "set_$name";
}

sub Moose::Meta::Attribute::Custom::Trait::Protobuf::Field::Scalar::register_implementation { __PACKAGE__ }

__PACKAGE__

__END__
