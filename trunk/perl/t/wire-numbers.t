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
use Math::BigInt;

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
    ['int32', -2**31, "\x08"."\x80\x80\x80\x80\xf8\xff\xff\xff\xff\x01"],
    ['int64', 0 - (BI(2) ** 63)]
    );

foreach my $t (@tests) {
    my ($type, $num, $expected_encoded) = @$t;
    $expected_encoded = "?" unless defined $expected_encoded;

    # they're all prefixed with optional in their name in this type:
    my $field = "optional_$type";

    my $p = ProtobufTestBasic::TestAllTypes->new;
    my $setter = "set_$field";

    # for _now_ only test success here. failing tests in the future.
    my $ok = eval { $p->$setter($num); 1; };

    ok($ok, "set $field to $num");
    is($p->$field(), $num, "  .. and field was set to $num");

    my $encoded = eval { $p->serialize_to_string; };
    if ($@) {
        diag("Got error encoding $type: $@");
    }
    bin_is($encoded, $expected_encoded, "  .. matches expected encoding");
}

