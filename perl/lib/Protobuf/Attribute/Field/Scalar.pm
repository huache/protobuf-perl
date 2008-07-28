package Protobuf::Attribute::Field::Scalar;
use Moose::Role;

with q(Protobuf::Attribute::Field);

sub _process_options {
    my ( $class, $name, $options ) = @_;

    $options->{reader} = $name;
    $options->{writer} = "set_$name";
    $options->{predicate} = "has_$name";
}

sub Moose::Meta::Attribute::Custom::Trait::Protobuf::Field::Scalar::register_implementation { __PACKAGE__ }

__PACKAGE__

__END__
