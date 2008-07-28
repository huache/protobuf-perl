#!/usr/bin/perl

use Test::More 'no_plan';
use Data::Dumper;

use lib "t/lib";
use Test::Protobuf;

use_ok("Protobuf::WireFormat");
my $F;

diag("zigzag_encode tests:");
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

diag("zigzag_decode tests:");
$F = \&Protobuf::WireFormat::zigzag_decode;
is($F->(0), 0);
is($F->(1), -1);
is($F->(2), 1);
is($F->(3), -2);
is($F->(4), 2);
is($F->(0xfffffffe), 0x7fffffff);
is($F->(0xffffffff), -0x80000000);
is($F->(BI("0xfffffffffffffffe")),  BI("0x7fffffffffffffff"));
is($F->(BI("0xffffffffffffffff")), -BI("0x8000000000000000"));
