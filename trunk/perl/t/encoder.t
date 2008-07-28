#!/usr/bin/perl

use strict;
use warnings;

use Test::More 'no_plan';

use_ok("Protobuf::Encoder");

my $e = Protobuf::Encoder->new;

sub escaped {
    my $v = shift;
    $v =~ s/([^[:print:]\n])/"\\x" . sprintf("%02x", ord($1))/eg;
    return $v;
}

sub bin_is ($$;$) {
    my @args = @_;
    foreach my $buf ( @args[0,1] ) { # copy because of readonly assignment
        fail("found utf8 data") if utf8::is_utf8($buf);
        $buf = escaped($buf);
    }

    @_ = @args;
    goto \&is;
}

bin_is( $e->encode_varint(0), "\x00" );
bin_is( $e->encode_varint(1), "\x01" );
bin_is( $e->encode_varint(2), "\x02" );
bin_is( $e->encode_varint(127), "\x7f" );
bin_is( $e->encode_varint(128), "\x80\x01" );
bin_is( $e->encode_varint(150), "\x96\x01" );
bin_is( $e->encode_varint(16384), "\x80\x80\x01" );

bin_is( $e->encode_varint_field(1, 150), "\x08\x96\x01");

bin_is( $e->encode_string("testing"), "\x07\x74\x65\x73\x74\x69\x6e\x67" );

bin_is( $e->encode_string_field(2, "testing"), "\x12\x07\x74\x65\x73\x74\x69\x6e\x67" );

bin_is( $e->encode_field_and_wire(2, 2), "\x12" );
bin_is( $e->encode_field_and_wire(128, 2), "\x82\x08" );

bin_is(
    join('',
        $e->encode_start_group(1),
        $e->encode_string_field(2, "foo"),
        $e->encode_string_field(3, "VALUE_OF_FOO"),
        $e->encode_4_byte_field(4, "{\x00\x00\x00"),
        $e->encode_end_group(1),
    ),
    "\x0b\x12\x03foo\x1a\x0cVALUE_OF_FOO%{\x00\x00\x00\x0c",
);


bin_is(
    join('',
        $e->encode_start_group(1),
        $e->encode_string_field(2, "foo"),
        $e->encode_string_field(3, "FOO_VALUE"),
        $e->encode_varint_field(5, 1),
        $e->encode_4_byte_field(6, "\xff\x00\x00\x00"),
        $e->encode_end_group(1),
    ),
    "\x0b\x12\x03foo\x1a\tFOO_VALUE(\x015\xff\x00\x00\x00\x0c",
);

bin_is(
    join('',
        $e->encode_varint_field(1, 1),
        $e->encode_varint_field(1, 2),
        $e->encode_varint_field(1, 3),
        $e->encode_varint_field(1, 250),
    ),
    "\x08\x01\x08\x02\x08\x03\x08\xfa\x01"
)
