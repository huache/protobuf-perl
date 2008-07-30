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

ok(-2**31 < 0, "less than zero");

my @tests = (
    ['int32', -2**31],
    );
