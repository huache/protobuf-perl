#!/usr/bin/perl

use strict;
use warnings;

use Test::More 'no_plan';

use_ok("Protobuf::Encoder");

my $e = Protobuf::Encoder->new;

sub bin_is ($$;$) {
    my @args = @_;
    foreach my $buf ( @args[0,1] ) { # copy because of readonly assignment
        fail("found utf8 data") if utf8::is_utf8($buf);
        $buf = unpack("H*",$buf);
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

bin_is( $e->encode_varbuf("testing"), "\x07\x74\x65\x73\x74\x69\x6e\x67" );

bin_is( $e->encode_field_and_wire(2, 2), "\x12" );
bin_is( $e->encode_field_and_wire(128, 2), "\x82\x08" );

