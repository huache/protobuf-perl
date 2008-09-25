package Protobuf::Attribute::Field;
use Moose::Role;

use Protobuf::Types;
use Moose::Util::TypeConstraints ();

requires 'protobuf_emit';

use namespace::clean -except => 'meta';

has field => (
    isa => "Protobuf::FieldDescriptor",
    is  => "ro",
    required => 1,
    handles => [qw(is_repeated message_type enum_type)],
);

has '+type_constraint' => (
    required => 1,
);

sub field_to_type_constraint {
    my ( $class, $field ) = @_;

    if ( my $message_desc = $field->message_type ) {
        return Moose::Util::TypeConstraints::find_or_create_isa_type_constraint($message_desc->class_name);
    } elsif ( my $enum = $field->enum_type) {
        # create FIXME type constraint (range check)
    }

    return type_constraint($field->type);
};

our %generatedenumvalues = ();

after 'install_accessors' => sub {
    my $self = shift;

    if ( my $enum = $self->enum_type ) {
        my $class_name = $self->associated_class->name;
        foreach my $value ( @{ $enum->values } ) {
            my $fqname = join("::", $class_name, $enum->name, $value->name);
            # failing to fully qualify generatedenumvalues causes a weird
            # error message about dereferencing an unused scalar
            if (! exists $__PACKAGE__::generatedenumvalues{$fqname}) {
                my $number = $value->number;
                no strict 'refs';
                *$fqname = sub () { $number };
                $__PACKAGE__::generatedenumvalues{$fqname} = 1;
            }
        }
    }
};

sub Moose::Meta::Attribute::Custom::Trait::Protobuf::Field::register_implementation { __PACKAGE__ }

__PACKAGE__

__END__
