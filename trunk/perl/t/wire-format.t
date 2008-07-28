#!/usr/bin/perl

use Test::More 'no_plan';
use Data::Dumper;
use Math::BigInt lib => 'GMP';

use_ok("Protobuf::WireFormat");
my $F;
sub BI {
    return Math::BigInt->new($_[0]);
}

$F = \&Protobuf::WireFormat::zigzag_encode;
is($F->(0), 0);
is($F->(-1), 1);
is($F->(1), 2);
is($F->(-2), 3);
is($F->(2), 4);
is($F->(0x7fffffff), 0xfffffffe);
is($F->(-0x80000000), 0xffffffff);
is($F->( BI("0x7fffffffffffffff")), BI("0xfffffffffffffffe"));
is($F->(-BI("0x8000000000000000")), BI("0xffffffffffffffff"));



