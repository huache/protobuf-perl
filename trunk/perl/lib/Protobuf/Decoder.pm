package Protobuf::Decoder;
use strict;

sub decode {
    my ($class, $data) = @_;
    my @evt;
    pos($data) = 0;  # just to make sure.
    my $done = sub {
        return pos($data) == length($data);
    };
    my $get_varint = sub {
        die "Expected varint at position " . pos($data) unless
            $data =~ /\G([\x80-\xff]*[\x00-\x7f])/gc;
        my $varint_enc = $1;
        my $num = 0;
        my $bytes = 0;
        foreach my $byte (split(//, $varint_enc)) {
            my $byte_value = (ord($byte) & 0x7f) << (7 * $bytes++);
            $num += $byte_value;
        }
        return $num;
    };
    my $consume = sub {
        my $length = shift;
        if (pos($data) + $length > length($data)) {
            die "Truncated message in middle of $length byte value.\n";
        }
        my $value = substr($data, pos($data), $length);
        pos($data) += $length;
        return $value;
    };
    my $group_depth = 0;
    while (!$done->()) {
        my $field_and_wire = $get_varint->();
        my $wire_format = $field_and_wire & 7;  # bottom three bits.
        my $field_num = $field_and_wire >> 3;
        my $value = undef;
        if ($wire_format == 0) { # one more varint
            $value = $get_varint->();
        } elsif ($wire_format == 2) { # a varint saying length
            my $length = $get_varint->();
            $value = $consume->($length);
        } elsif ($wire_format == 1) {  # 64-bit
            $value = $consume->(8);
            # TODO(brafitz): decode?  or at later stage?
        } elsif ($wire_format == 5) {  # 32-bit
            $value = $consume->(4);
            # TODO(brafitz): decode?  or at later stage?
        } elsif ($wire_format == 3) {  # start group
            push @evt, {
                fieldnum => $field_num,
                type => "start_group",
            };
            $group_depth++;
            next;
        } elsif ($wire_format == 4) {  # end group
            push @evt, {
                fieldnum => $field_num,
                type => "end_group",
            };
            $group_depth--;
            next;
        } else {
            die "Unsupported wire format: $wire_format\n";
        }
        push @evt, {
            fieldnum => $field_num,
            value => $value,
        };
    }
    die "Still in a group after encountering the end of the stream." if $group_depth;
    return \@evt;
}

1;
