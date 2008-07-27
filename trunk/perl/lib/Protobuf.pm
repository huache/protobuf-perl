package Protobuf;
use strict;

our $VERSION = '0.01';

package Protobuf::EnumDescriptor;

use Moose::Policy 'Protobuf::AccessorNamingPolicy';
use Moose;

has 'name' => (is => 'rw', isa => 'Str');
has 'fullname' => (is => 'rw', isa => 'Str');

package Protobuf::EnumValueDescriptor;

use Moose::Policy 'Protobuf::AccessorNamingPolicy';
use Moose;

has 'name' => (is => 'rw', isa => 'Str');
has 'index' => (is => 'rw', isa => 'Int');
has 'number' => (is => 'rw', isa => 'Int');
has 'type' => (is => 'rw');  # TODO(bradfitz): isa what?

package Protobuf::MessageOptions;
use Moose;

package Protobuf::Descriptor;
use Moose;

has 'name' => (is => 'rw', isa => 'Str');
has 'full_name' => (is => 'rw', isa => 'Str');
has 'fields' => (is => 'rw', isa => 'ArrayRef[Protobuf::FieldDescriptor]');

sub class_name {
    my $self = shift;
    my $name = $self->full_name;
    $name =~ s/^appengine_api\.//; # TODO(bradfitz): Hack. temporary.
    $name =~ s/\./::/g;
    return $name;
}

sub fields_by_name {
    my ($self, $field_name) = @_;
    for my $field (@{ $self->fields }) {
        if ($field->name eq $field_name) {
            return $field;
        }
    }
    return undef;
}

package Protobuf::FieldDescriptor;
use Moose::Policy 'Protobuf::AccessorNamingPolicy';
use Moose;

has 'name' => (is => 'rw', isa => 'Str');
has 'message_type' => (is => 'rw', isa => 'Maybe[Protobuf::Descriptor]');
has 'enum_type' => (is => 'rw', isa => 'Maybe[Protobuf::EnumDescriptor]');

# label can be 1 (optional), 2 (required), 3 (repeated)
has 'label' => (is => 'rw', isa => 'Int'); # TODO(bradfitz): but only 1, 2, or 3.

has 'type' => (is => 'rw', isa => 'Int'); # TODO(bradfitz): but only [1,18]. see descriptor.proto

sub is_repeated {
    my $self = shift;
    return $self->label == 3;
}

sub is_optional {
    my $self = shift;
    return $self->label == 1;
}

sub is_required {
    my $self = shift;
    return $self->label == 2;
}

sub is_aggregate {
    my $self = shift;
    my $type = $self->type;
    # values from descriptor.proto: (TYPE_GROUP and TYPE_MESSAGE)
    # http://protobuf.googlecode.com/svn/trunk/src/google/protobuf/descriptor.proto
    return $type == 10 || $type == 11;
}

package Protobuf::Message;
use strict;

sub GenerateClass {
    my ($class, $name, $descriptor) = @_;
    my @attributes;
    my %methods;
    $methods{new} = sub {
        my ($class, %param) = @_;
        return $class->meta->new_object(%param);
    };

    foreach my $field_des (@{ $descriptor->fields }) {
        my $name = $field_des->name;
        warn "# in $name, field: $name\n";
        if ($field_des->is_repeated) {
            # adding a field of an aggregate type creates an item of that type.
            # otherwise it adds a simple type (string, int, etc)
            $methods{"add_$name"} = sub {
                my $self = shift;
                my $list = ($self->{$name} ||= []);

                if ($field_des->is_aggregate) {
                    die "not expecting any arguments" if scalar @_;
                    my $message_type = $field_des->message_type;
                    my $instance = $message_type->class_name->new;
                    push @$list, $instance;
                    return $instance;
                }

                my $value = shift;
                push @$list, $value;
                return;
            };
            $methods{"${name}s"} = sub {
                my $self = shift;
                return $self->{$name} || [];  # or empty list
            };
            $methods{"${name}_size"} = sub {
                my $self = shift;
                my $method_name = "${name}s";
                return scalar @{ $self->$method_name };
            };

        } else {
            my $attr = Class::MOP::Attribute->new(
                ('$' . $name) => (
                    reader => $name,
                    writer => "set_$name",
                    predicate => "has_$name",
                    # default => TODO(bradfitz): get default from fielddescriptor
                ));
            push @attributes, $attr;
        }
    }

    Class::MOP::Class->create(
        $name => (
            superclasses => ['Protobuf::Message'],
            attributes => \@attributes,
            methods => \%methods,
        ));
}

sub serialize_to_string {
    my ($self) = @_;
    return "XXX NOT DONE";
}

1;