#!/usr/bin/perl

use strict;
use warnings;

use Test::More 'no_plan';

use lib "t/lib";
use Test::Protobuf;


use_ok("Protobuf::Encoder");

use Protobuf::Types;

my $e = Protobuf::Encoder->new;

bin_is( $e->encode_varint(0), "\x00" );
bin_is( $e->encode_varint(1), "\x01" );
bin_is( $e->encode_varint(2), "\x02" );
bin_is( $e->encode_varint(127), "\x7f" );
bin_is( $e->encode_varint(128), "\x80\x01" );
bin_is( $e->encode_varint(150), "\x96\x01" );
bin_is( $e->encode_varint(16384), "\x80\x80\x01" );
bin_is( $e->encode_varint(BI(1) << 63), "\x80\x80\x80\x80\x80\x80\x80\x80\x80\x01" );

bin_is( $e->encode_wire_varint(1, 150), "\x08\x96\x01");
bin_is( $e->encode_wire(1, WIRE_VARINT, 150), "\x08\x96\x01");

bin_is( $e->encode_length_delimited("testing"), "\x07\x74\x65\x73\x74\x69\x6e\x67" );

bin_is( $e->encode_wire_length_delimited(2, "testing"), "\x12\x07\x74\x65\x73\x74\x69\x6e\x67" );
bin_is( $e->encode_wire(2, WIRE_LENGTH_DELIMITED, "testing"), "\x12\x07\x74\x65\x73\x74\x69\x6e\x67" );
bin_is( $e->encode_field_string(2, "testing"), "\x12\x07\x74\x65\x73\x74\x69\x6e\x67" );

bin_is( $e->encode_field_and_wire_type(2, 2), "\x12" );
bin_is( $e->encode_field_and_wire_type(128, 2), "\x82\x08" );

bin_is( $e->encode_field_fixed64(1, BI(1) << 63), "\x09\x00\x00\x00\x00\x00\x00\x00\x80" );

bin_is(
    join('',
        $e->encode_wire_start_group(1),
        $e->encode_wire_length_delimited(2, "foo"),
        $e->encode_wire_length_delimited(3, "VALUE_OF_FOO"),
        $e->encode_wire_fixed32(4, "{\x00\x00\x00"),
        $e->encode_wire_end_group(1),
    ),
    "\x0b\x12\x03foo\x1a\x0cVALUE_OF_FOO%{\x00\x00\x00\x0c",
);


bin_is(
    join('',
        $e->encode_wire_start_group(1),
        $e->encode_wire_length_delimited(2, "foo"),
        $e->encode_wire_length_delimited(3, "FOO_VALUE"),
        $e->encode_wire_varint(5, 1),
        $e->encode_wire_fixed32(6, "\xff\x00\x00\x00"),
        $e->encode_wire_end_group(1),
    ),
    "\x0b\x12\x03foo\x1a\tFOO_VALUE(\x015\xff\x00\x00\x00\x0c",
);

bin_is(
    join('',
        $e->encode_wire_varint(1, 1),
        $e->encode_wire_varint(1, 2),
        $e->encode_wire_varint(1, 3),
        $e->encode_wire_varint(1, 250),
    ),
    "\x08\x01\x08\x02\x08\x03\x08\xfa\x01"
)
