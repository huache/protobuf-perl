#!/usr/bin/perl

use strict;
use warnings;
use Test::More 'no_plan';
use FindBin qw($Bin);

use lib "$Bin/lib";
use Test::Protobuf;

use lib "$Bin/autogen";
use_ok("ProtobufTestBasic");  # unittest_basic.proto

use Protobuf::Encoder;
use Protobuf::Types;
use Math::BigInt lib => 'GMP';

my $max_u64 = BI("18446744073709551615");
my $max_u32 = 4294967295; # a perl UV.  should work on 32-bit. or BI("4294967295")
is("$max_u32", "4294967295", "max_u32 literal works") or die;

{
    my $p = ProtobufTestBasic::TestAllTypes->new;
    ok(eval { $p->set_optional_fixed32($max_u32); 1}, "setting maxu32 works")
        or diag("Error: $@");
    is($p->optional_fixed32, $max_u32, "got the u32 value back.");
}

# The numbers from unittest.proto's TestAllTypes.
# Use devtools/python-proto-shell.sh to play with this.
# >>> p = unittest.TestAllTypes()
# >>> p.optional_int32 = 7
# >>> p.SerializeToString()
#     '\x08\x07'
my %field_number = (
    'int32' => 1,
    'int64' => 2,
    'uint32' => 3,
    'uint64' => 4,
    'sint32' => 5,
    'sint64' => 6,
    'fixed32' => 7,
    'fixed64' => 8,
    'sfixed32' => 9,
    'sfixed64' => 10,
    'float' => 11,
    'double' => 12,
    'bool' => 13,
    );

# tests to run:
my @tests = (
    ['int32',      7, "\x08"."\x07"],
    ['int32',     -7, "\x08"."\xf9\xff\xff\xff\xff\xff\xff\xff\xff\x01"],
    ['int32', -2147483648, "\x08"."\x80\x80\x80\x80\xf8\xff\xff\xff\xff\x01"],

    ['int64', 0-(BI(2)**63), "\x10"."\x80\x80\x80\x80\x80\x80\x80\x80\x80\x01"],

    ['uint32',  $max_u32, "\x18"."\xff\xff\xff\xff\x0f"],
    ['uint32',  7, "\x18"."\x07"],

    ['uint64',  $max_u64, " "."\xff\xff\xff\xff\xff\xff\xff\xff\xff\x01"],
    ['uint64',  7, " "."\x07"],

    ['sint32', -7, "("."\r"],
    ['sint32',  7, "("."\x0e"],
    ['sint32', -2147483648, "("."\xff\xff\xff\xff\x0f"],

    ['sint64', -7, "0"."\r"],
    ['sint64',  7, "0"."\x0e"],
    ['sint64',  BI("-9223372036854775808"),
     "0\xff\xff\xff\xff\xff\xff\xff\xff\xff\x01"],

    ['fixed32', $max_u32, "="."\xff"x4],
    ['fixed32', 7, "=\x07\0\0\0"],

    ['fixed64', $max_u64, "A"."\xff"x8],
    ['fixed64', 7, "A"."\x07\0\0\0\0\0\0\0"],

    ['sfixed32',  7, "M"."\x07\0\0\0"],
    ['sfixed32', -2**31, "M"."\x00\x00\x00\x80"],
    ['sfixed32', 2147483647, "M"."\xff\xff\xff\x7f"],

    ['sfixed64',  7, "Q"."\x07\0\0\0\0\0\0\0"],
    ['sfixed64', BI("-9223372036854775808"),
     "Q"."\x00\x00\x00\x00\x00\x00\x00\x80"],
    ['sfixed64', BI("9223372036854775807"),
     "Q"."\xff\xff\xff\xff\xff\xff\xff\x7f"],

    ['float', 1.0/3.0, "]"."\xab\xaa\xaa>"],
    ['double', 1.0/3.0, "a"."UUUUUU\xd5?"],
    );

foreach my $t (@tests) {
    my ($type, $num, $expected_encoded) = @$t;
    my $wire = type_to_wire($type);
    $expected_encoded = "?" unless defined $expected_encoded;

    # they're all prefixed with optional in their name in this type:
    my $field = "optional_$type";

    my $p = ProtobufTestBasic::TestAllTypes->new;
    %$p = ();
    my $setter = "set_$field";

    # for _now_ only test success here. failing tests in the future.
    my $ok = eval { $p->$setter($num); 1; } or
        diag("Set failure: $@");

    ok($ok, "set $field to $num");

    my $value_check = sub {
        my ($pi, $phase) = @_;
        if ($type eq "float") {
            my $got = $pi->$field();
            ok($got > $num-0.05 && $got < $num+0.05, "  .. and float field $phase is close enough.");
        } else {
            is($pi->$field(), $num, "  .. and field $phase was set to $num");
        }
    };

    $value_check->($p, "encoded");

    my $encoded = eval { $p->serialize_to_string };
    if ($@) {
        diag("Got error encoding $type: $@");
    }
    bin_is($encoded, $expected_encoded, "  .. $type $num matches expected encoding");

    # now see if we can decode it
    my $p2 = ProtobufTestBasic::TestAllTypes->new;
    $ok = eval { $p2->parse_from_string($expected_encoded); 1 } or
        diag("Parse failure: $@");
    ok($ok, "  .. and parsed it ($type $num $wire)");
    is($p2->$field(), $num, "  .. and parsed value was correctly set ($type $num)");
}

