package Protobuf::Decoder;
use strict;
use warnings;

use Protobuf::Types;

sub decode {
    my ($class, $data) = @_;

    # array of events to return
    my @evt;

    # reset where \G will match, just in case it's not zero already.
    pos($data) = 0;

    # consumes a varint from the front of the stream
    my $get_varint = sub {
        die "Expected varint at position " . pos($data) unless
            $data =~ /\G([\x80-\xff]*[\x00-\x7f])/gc;
        my $varint_enc = $1;
        my $num = 0;
        my $bytes = length($varint_enc) > 4 && !HAS_QUADS ? Math::BigInt->new(0) : 0;
        foreach my $byte (split(//, $varint_enc)) {
            my $byte_value = (ord($byte) & 0x7f) << (7 * $bytes++);
            $num += $byte_value;
        }
        return $num;
    };

    # consumes n bytes from the front of the stream.
    my $consume = sub {
        my $length = shift;
        if (pos($data) + $length > length($data)) {
            die "Truncated message in middle of $length byte value.\n";
        }
        my $value = substr($data, pos($data), $length);
        pos($data) += $length;
        return $value;
    };

    # loop while we have still have data to parse.
    my $group_depth = 0;
    while (pos($data) != length($data)) {
        my $field_and_wire = $get_varint->();
        my $wire_format = $field_and_wire & 7;  # bottom three bits.
        my $field_num = $field_and_wire >> 3;
        my $value = undef;
        if ($wire_format == WIRE_VARINT) { # one more varint
            $value = $get_varint->();
        } elsif ($wire_format == WIRE_LENGTH_DELIMITED) { # a varint saying length
            my $length = $get_varint->();
            $value = $consume->($length);
        } elsif ($wire_format == WIRE_FIXED64) {  # 64-bit
            $value = $consume->(8);
            # TODO(brafitz): decode?  or at later stage?
        } elsif ($wire_format == WIRE_FIXED32) {  # 32-bit
            $value = $consume->(4);
            # TODO(brafitz): decode?  or at later stage?
        } elsif ($wire_format == WIRE_START_GROUP) {  # start group
            push @evt, {
                fieldnum => $field_num,
                type => "start_group",
            };
            $group_depth++;
            next;
        } elsif ($wire_format == WIRE_END_GROUP) {  # end group
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

# TODO(bradfitz): lame implementation for now, but leaves possibility
# for better one later.
sub decode_iterator {
    my ($class, $dataref) = @_;
    my @events = @{ $class->decode($$dataref) };
    return Protobuf::Decoder::EventIterator->new(\@events);
}

package Protobuf::Decoder::EventIterator;
use strict;

sub new {
    my ($class, $listref, $group_depth) = @_;
    return bless {
        events => $listref,
        group_depth => $group_depth,
    };
}

sub next {
    my $self = shift;
    my $event = shift @{ $self->{events} } or
        return undef;
    return $event unless defined $self->{group_depth};
    if ($event->{type}) {
        if ($event->{type} eq "start_group") {
            $self->{group_depth}++;
        } elsif ($event->{type} eq "end_group") {
            $self->{group_depth}--;
            if ($self->{group_depth} == 0) {
                return undef;
            }
        } else {
            die "assert: unexpected type";
        }
    }
    return $event;
}

# Create an iterator from an iterator which is backed by the same
# event stream, but stops when the group depth goes to zero.  (returns
# an 'undef' event in place of the closing end_group).  Only valid to
# create one of these when you just read in a 'start_group' event.
sub subgroup_iterator {
    my $self = shift;
    return __PACKAGE__->new($self->{events}, 1);
}

1;
