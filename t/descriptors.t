#!/usr/bin/perl

use Test::More tests => 4;
use Protobuf;

my $enum = Protobuf::EnumDescriptor->new(
    name => 'ErrorCode',
    fullname => "Foo.NewCode",
    );

ok($enum);
is($enum->name, "ErrorCode");
$enum->set_name("NewCode");
is($enum->name, "NewCode");

is($enum->fullname, "Foo.NewCode");

