package Protobuf::Attribute::Field::Scalar;
use Moose::Role;

use Protobuf::Types qw(type_constraint);
use Storable qw(dclone);

# 5.8 doesn't have this: -brad
#use namespace::clean -except => 'meta';

with q(Protobuf::Attribute::Field);

before _process_options => sub {
    my ( $class, $name, $options ) = @_;

    $options->{reader}    ||= $name;
    $options->{writer}    ||= "set_$name";
    $options->{predicate} ||= "has_$name";

    my $field = $options->{field};

    my $type_constraint = $options->{type_constraint} ||= type_constraint($field->type);

    if ( defined ( my $default = $field->default_value ) ) {
        $options->{lazy} = 1;
        $options->{default} = $class->process_default($default, $type_constraint);
    } elsif ( $type_constraint->isa("Moose::Meta::TypeConstraint::Class") ) {
        my $class = $type_constraint->class;
        $options->{default} = sub { $class->new };
    }

    if ( $type_constraint->is_a_type_of("Math::BigInt") ) {
        $options->{coerce} = 1;
    }
};

sub process_default {
    my ( $class, $default, $type_constraint ) = @_;

    if ( $type_constraint and !$type_constraint->check($default) ) {
        if ( $type_constraint->has_coercion ) {
            $default = $type_constraint->coerce($default);
        } else {
            die $type_constraint->get_message($default);
        }
    }

    unless ( ref $default ) {
        return $default;
    } else {
        if ( blessed($default) ) {
            if ( $default->isa("Math::BigInt" ) ) {
                return sub { $default->copy };
            }
        } elsif ( ref $default eq 'ARRAY' ) {
            return ( @$default ? sub { [ @$default ] } : sub { [] } );
        } elsif ( ref $default eq 'HASH' ) {
            return ( keys %$default ? sub { { %$default } } : sub { {} } );
        }

        return sub {
            # FIXME clone when applicable, but only when applicable
            # optimize simple refs
            return dclone($default);
        }
    }
}

sub Moose::Meta::Attribute::Custom::Trait::Protobuf::Field::Scalar::register_implementation { __PACKAGE__ }

__PACKAGE__

__END__
