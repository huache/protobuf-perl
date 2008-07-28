package Protobuf::Attribute::Field;
use Moose::Role;

has field => (
	isa => "Protobuf::FieldDescriptor",
	is  => "ro",
	required => 1,
);

has '+type_constraint' => (
    required => 1,
);

sub Moose::Meta::Attribute::Custom::Trait::Protobuf::Field::register_implementation { __PACKAGE__ }

__PACKAGE__

__END__
