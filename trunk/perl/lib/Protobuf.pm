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

require Protobuf::Attribute::Field::Repeated;
require Protobuf::Attribute::Field::Scalar;

sub GenerateClass {
    my ($class, $name, $descriptor) = @_;

    my %methods;
    $methods{new} = sub {
        my ($class, %param) = @_;
        return $class->meta->new_object(%param);
    };

    $methods{serialize_to_string} = sub {
        my $self = shift;
        my $fields_ref = $descriptor->fields;
        return Protobuf::Message::serialize_to_string($self, $fields_ref);
    };

    my @attributes = map { 
        Moose::Meta::Attribute->interpolate_class_and_new( $_->name => (
            traits => [ 'Protobuf::Field::' . ( $_->is_repeated ? 'Repeated' : 'Scalar' ) ],
            field => $_,
        ));
    } @{ $descriptor->fields };

    Moose::Meta::Class->create(
        $name => (
            superclasses => ['Protobuf::Message'],
            attributes => \@attributes,
            methods => \%methods,
        ));
}

# each auto-generated class overrides serialize_to_string just to
# capture its field list and pass it to us here.
sub serialize_to_string {
    my ($self, $fieldsref) = @_;
    my $buf = '';

  FIELD:
    foreach my $field (@$fieldsref) {
        my $name = $field->name;
        my $emit = sub {
            my ($value) = @_;
            # TODO(bradfitz): ...
        };
        if ($field->is_repeated) {
            my $size_method = "${name}_size";
            next FIELD unless $self->$size_method > 0;
            $buf .= "[$name-repeated:";
            my $list_method = "${name}s";
            for my $value (@{ $self->$list_method }) {
                $buf .= "[$name-$value]";
                # TODO(bradfitz): if it's ::isa("Protobuf::Message") emit it
            }
            $buf .= "]";
        } else {
            my $has_method = "has_${name}";
            my $has_it = $self->$has_method;
            if ($field->is_required && !$has_it) {
                die "Missing required field '$name'\n";
            }
            next FIELD unless $has_it;
            $buf .= "[$name-single]";
        }
    }
    return $buf;
}

1;
