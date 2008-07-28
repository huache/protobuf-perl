package Protobuf::WireFormat;
use strict;
use warnings;

sub zigzag_encode {
    my ($v) = @_;
    if ($v >= 0) {
        return $v << 1;
    }
    return (($v << 1) ^ -1) | 0x1;
}

1;
