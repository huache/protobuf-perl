package Protobuf;
use strict;

our $VERSION = '0.01';

package Protobuf::EnumDescriptor;

use Moose::Policy 'Protobuf::AccessorNamingPolicy';
use Moose;

has 'name' => (is => 'rw', isa => 'Str');
has 'fullname' => (is => 'rw', isa => 'Str');

has 'values' => (is => 'rw', isa => 'ArrayRef[Protobuf::EnumValueDescriptor]' );

__PACKAGE__->meta->make_immutable;

package Protobuf::EnumValueDescriptor;

use Moose::Policy 'Protobuf::AccessorNamingPolicy';
use Moose;

has 'name' => (is => 'rw', isa => 'Str');
has 'index' => (is => 'rw', isa => 'Int');
has 'number' => (is => 'rw', isa => 'Int');
has 'type' => (is => 'rw', isa => 'Maybe[Protobuf::EnumDescriptor]');

__PACKAGE__->meta->make_immutable;

package Protobuf::MessageOptions;
use Moose;

__PACKAGE__->meta->make_immutable;

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

__PACKAGE__->meta->make_immutable;

package Protobuf::FieldDescriptor;
use Moose::Policy 'Protobuf::AccessorNamingPolicy';
use Moose;

has [qw(index number)] => (is => 'rw', isa => 'Int');
has 'name' => (is => 'rw', isa => 'Str');
has 'message_type' => (is => 'rw', isa => 'Maybe[Protobuf::Descriptor]');
has 'enum_type' => (is => 'rw', isa => 'Maybe[Protobuf::EnumDescriptor]');

# can be arrayref (?), int, string, ...
has 'default_value' => (is => 'rw', isa => 'Any');

# label can be 1 (optional), 2 (required), 3 (repeated)
has 'label' => (is => 'rw', isa => 'Int'); # TODO(bradfitz): but only 1, 2, or 3.

has 'type' => (is => 'rw', isa => 'Int'); # TODO(bradfitz): but only [1,18]. see descriptor.proto

has 'default_value' => ( is => 'rw' );

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

__PACKAGE__->meta->make_immutable;

package Protobuf::Message;
use strict;
use warnings;

use Protobuf::Meta::Message ();

use namespace::clean;

sub GenerateClass {
    my ($class, $name, $descriptor) = @_;

    my $c = Protobuf::Meta::Message->create_from_descriptor(
        descriptor => $descriptor,
        class      => $name,
    );

    $c->make_immutable;

    return $c;
}

1;
