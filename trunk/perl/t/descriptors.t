#!/usr/bin/perl

use Test::More tests => 11;
use Protobuf;

use Moose::Util qw(does_role);

my $enum = Protobuf::EnumDescriptor->new(
    name => 'ErrorCode',
    fullname => "Foo.NewCode",
    );

ok($enum);
is($enum->name, "ErrorCode");
$enum->set_name("NewCode");
is($enum->name, "NewCode");

is($enum->fullname, "Foo.NewCode");

my $field = Protobuf::FieldDescriptor->new(
	name => "Name",
	fullname => "Foo.NewName",
);

ok($field);

is( $field->name, "Name" );
$enum->set_name("NewCode");
is($enum->name, "NewCode");

my $attr = Moose::Meta::Attribute->interpolate_class_and_new( blah => 
	traits => [qw(Protobuf::Field)],
	field  => $field,
);

isa_ok( $attr, "Moose::Meta::Attribute" );

ok( does_role( $attr, "Protobuf::Attribute::Field" ), "attr does Field role" );

can_ok( $attr, "field" );

is( $attr->field, $field, 'field atrribute of meta attribute' );
