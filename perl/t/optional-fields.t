#!/usr/bin/perl

use strict;
use warnings;
use Test::More 'no_plan';
use FindBin qw($Bin);

use lib "$Bin/lib";
use Test::Protobuf;

use lib "$Bin/autogen";
use_ok("ProtobufTestBasic");  # unittest_basic.proto

my $p = ProtobufTestBasic::TestAllTypes->new;
ok(!$p->has_optional_int32, "doesn't have optional int32");
$p->set_optional_int32(42);
is($p->optional_int32, 42, "does it's set.");
ok($p->has_optional_int32, "and has field.");

ok(!$p->has_optional_nested_message, "doesn't have optional NestedMessage");
ok($p->optional_nested_message, "true.  got a new default one constructed.");
ok($p->has_optional_nested_message, "and that vivified it.");



