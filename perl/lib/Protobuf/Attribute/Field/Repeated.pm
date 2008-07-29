package Protobuf::Attribute::Field::Repeated;
use Moose::Role;

use Moose::Util::TypeConstraints;
use Protobuf::Types;

use namespace::clean -except => 'meta';

with q(Protobuf::Attribute::Field);

before _process_options => sub {
    my ( $class, $name, $options ) = @_;

    $options->{reader}    ||= "${name}s";
    $options->{predicate} ||= "set_$name";
    $options->{default}   ||= sub { [] }; # FIXME can it be anything else?
    $options->{clearer}   ||= "clear_$name";
    $options->{lazy} = 1;  # so the default is used ([]), not undef

    $options->{type_constraint} = $class->field_to_type_constraint($options->{field});
};

around field_to_type_constraint => sub {
    my ( $next, $self, $field ) = @_;

    my $type_constraint = $self->$next($field);

    return Moose::Meta::TypeConstraint::Parameterized->new(
        name           => 'ArrayRef[' . $type_constraint->name . ']',
        parent         => find_type_constraint('ArrayRef'),
        type_parameter => $type_constraint,
    );
};

after 'install_accessors' => sub {
    my $self = shift;

    my $name = $self->name;

    $self->_wrap_and_install_method( "add_$name"    => $self->generate_add_method );
    $self->_wrap_and_install_method( "${name}_size" => $self->generate_size_method );
};

sub _wrap_and_install_method {
    my ( $self, $name, $body ) = @_;

    my $class = $self->associated_class;

    my $method = Moose::Meta::Method->wrap( $body,
        name         => $name,
        package_name => $class->name,
    );

    $self->associate_method($method);

    $class->add_method($name => $method);
}

sub generate_size_method {
    my $self = shift;
    my $reader = $self->get_read_method_ref->body;
    return sub {
        my $self = shift;
        return scalar @{ $self->$reader() };
    };
}

sub generate_add_method {
    my $self = shift;

    if ( $self->field->is_aggregate ) {
        return $self->generate_aggregate_add_method;
    } else {
        return $self->generate_simple_add_method;
    }
}

sub generate_aggregate_add_method {
    my $self = shift;

    my $reader = $self->get_read_method_ref->body;
    my $item_class = $self->field->message_type->class_name;

    return sub {
        my $self = shift;
        die "not expecting any arguments" if scalar @_;

        my $list = $self->$reader();
        my $instance = $item_class->new;
        push @$list, $instance;
        return $instance;
    };
}

sub generate_simple_add_method {
    my $self = shift;

    my $reader = $self->get_read_method_ref->body;

    return sub {
        my ( $self, $value ) = @_;
        push @{ $self->$reader }, $value;
        return;
    }
}

# TODO(bradfitz): nothingmuch should audit this. :)
sub push_value {
    my ($self, $instance, $value) = @_;
    my $reader = $self->get_read_method_ref->body;
    push @{ $instance->$reader }, $value;
}

sub protobuf_emit {
    my ( $self, $instance, $emit ) = @_;

    my $field = $self->field;

    foreach my $value ( @{ $self->get_value($instance) } ) {
        $emit->($field, $value);
    }
}

sub Moose::Meta::Attribute::Custom::Trait::Protobuf::Field::Repeated::register_implementation { __PACKAGE__ }

__PACKAGE__

__END__
