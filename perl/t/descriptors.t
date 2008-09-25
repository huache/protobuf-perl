#!/usr/bin/perl

use Test::More tests => 11;
use Protobuf;
use Protobuf::Types;

use Moose::Util qw(does_role);

my $enum = Protobuf::EnumDescriptor->new(
    name => 'ErrorCode',
    full_name => "Foo.NewCode",
);

ok($enum);
is($enum->name, "ErrorCode");
$enum->set_name("NewCode");
is($enum->name, "NewCode");

is($enum->full_name, "Foo.NewCode");

my $field = Protobuf::FieldDescriptor->new(
    name => "Name",
    full_name => "Foo.NewName",
    type => TYPE_STRING,
);

ok($field);

is( $field->name, "Name" );
$enum->set_name("NewCode");
is($enum->name, "NewCode");

my $attr = Moose::Meta::Attribute->interpolate_class_and_new( blah => 
    traits => [qw(Protobuf::Field::Scalar)],
    field  => $field,
);

isa_ok( $attr, "Moose::Meta::Attribute" );

ok( does_role( $attr, "Protobuf::Attribute::Field" ), "attr does Field role" );

can_ok( $attr, "field" );

is( $attr->field, $field, 'field attribute of meta attribute' );
