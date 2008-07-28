package Protobuf::WireFormat;
use strict;
use warnings;

use Protobuf::Types;

sub zigzag_encode {
    my ($v) = @_;
    if ($v >= 0) {
        return $v << 1;
    }
    return (($v << 1) ^ -1) | 0x1;
}

sub zigzag_decode {
    my $v = $_[0];
    if (1 & $v) {
        return -( 1 + ($v >> 1) ); 
        # ( $v >> 1 ) ^ -1; # if we do this (like the google ref) we get a UV instead of an IV on 64 bit ints
    } else {
        return $v >> 1;
    }
}


1;
