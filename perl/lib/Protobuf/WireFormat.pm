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
        return ($v >> 1) ^ ( HAS_QUADS ? -1 : Math::BigInt->new(-1) );
    } else {
        return $v >> 1;
    }
}

1;
