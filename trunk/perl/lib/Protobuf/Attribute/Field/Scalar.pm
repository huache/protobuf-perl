package Protobuf::Attribute::Field::Scalar;
use Moose::Role;

use Protobuf::Types qw(type_constraint);
use Storable qw(dclone);

use namespace::clean -except => 'meta';

with q(Protobuf::Attribute::Field);

before _process_options => sub {
    my ( $class, $name, $options ) = @_;

    $options->{reader} = $name;
    $options->{writer} = "set_$name";
    $options->{predicate} = "has_$name";

    my $field = $options->{field};

    my $type_constraint = $options->{type_constraint} ||= type_constraint($field->type);

    if ( defined ( my $default = $field->default_value ) ) {
        $options->{lazy} = 1;
        if ( $type_constraint and !$type_constraint->check($default) ) {
            if ( $type_constraint->has_coercion ) {
                $default = $type_constraint->coerce($default);
            } else {
                die $type_constraint->get_message($default);
            }
        }

        if ( ref $default ) {
            my $value = $default;
            $default = sub {
                warn "returning $value for $name";
                # FIXME clone when applicable, but only when applicable
                # optimize simple refs
                return dclone($value);
            };
        }
        $options->{default} = $default;
    }
};

sub Moose::Meta::Attribute::Custom::Trait::Protobuf::Field::Scalar::register_implementation { __PACKAGE__ }

__PACKAGE__

__END__
