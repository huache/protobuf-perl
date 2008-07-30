package Protobuf::Decoder;
use strict;
use warnings;

use Protobuf::Types;
use Protobuf::WireFormat;

# decode a value (as gotten from 'decode' below) once we know its attribute
# type.  only with that can we properly decode it from its blob on the wire.
# note that varints have already been converted to IVs/UVs/BigInts.
sub decode_value {
    my ($class, $attr, $value) = @_;
    my $type_name = lc type_name($attr->field->type);
    my $method = "decode_field_" . $type_name;
    unless ($class->can($method)) {
        # by default
        return $value;
    }
    return $class->$method($value);
}

sub decode_field_float {
    my ($class, $v) = @_;
    die 'assert: should be 8 bytes' unless length($v) == 4;
    return unpack("f", $v);
}

sub decode_field_double {
    my ($class, $v) = @_;
    die 'assert: should be 8 bytes' unless length($v) == 8;
    return unpack("d", $v);
}

sub decode_field_sint32 {
    my ($class, $v) = @_;
    return Protobuf::WireFormat::zigzag_decode($v);
}

sub decode_field_sint64 {
    my ($class, $v) = @_;
    return Protobuf::WireFormat::zigzag_decode($v);
}

# Decode a wire stream into arrayref of 'events' (hashref of parts
# of the stream)
# TODO(bradfitz): rename this to 'decode_wire' or something.
sub decode {
    my ($class, $data) = @_;

    # array of events to return
    my @evt;

    # reset where \G will match, just in case it's not zero already.
    pos($data) = 0;

    # consumes a varint from the front of the stream
    my $get_varint = sub {
        die "Expected varint at position " . pos($data) unless
            $data =~ /\G([\x80-\xff]{0,9}[\x00-\x7f])/gc;

        my $varint_enc = $1;

        my @bytes = map { $_ & 0x7f } unpack("C*", $varint_enc);

        # 7 bit clumps concatenated in big endian order, followed by 8 bit clumps &x7f
        #warn join " ", unpack("(a8)*", join("", unpack("(xa7)*", unpack("B*", pack("C*", @bytes)))));
        #warn join " ", map { unpack("B*", pack("C", $_)) } @bytes;

        my $neg;
        
        if ( @bytes == 10 ) { # signed
            $neg = 1;
            pop @bytes;

            # remove padding for sign
            while ( $bytes[-1] == 0x7f ) {
                pop @bytes;
                if ( @bytes == 5 ) {
                    # throw away high nybble, method varies according to alignment
                    # this nybble is set due to padding. The fourth octet ends
                    # at the low nybble of the 5th byte due to 7 bit encoding,
                    # so this data is only used for the sign.
                    if ( ( $bytes[-1] & 0x70 ) == 0x70 ) {
                        $bytes[-1] &= 0x0f;
                    } else {
                        warn join " ", unpack("(a8)*", join("", reverse unpack("(xa7)*", unpack("B*", pack("C*", @bytes)))));
                        warn join " ", map { unpack("B*", pack("C", $_)) } @bytes;
                        die "shouldn't happen";
                    }
                    last;
                }
            }
        }

        pop @bytes while @bytes and not $bytes[-1];

        my $num = 0;
        my $shift = 0;

        if ( !HAS_QUADS and ( @bytes > 5 or @bytes == 5 && ( $bytes[-1] & 0x70 ) ) ) {
            $shift = Math::BigInt->new(0);
        }

        foreach my $byte (@bytes) {
            #warn "shifting " . unpack("H*", pack("N", $byte & 0x7f)), " by " . ( 7 * $shift) . " == " . Math::BigInt->new(($byte & 0x7f) << (7 * $shift))->as_hex;
            my $byte_value = ($byte & 0x7f) << (7 * $shift++);
            $num |= $byte_value;
            #warn Math::BigInt->new($num)->as_hex;
        }

        if ( $neg ) { 
            if ( $num == 0 ) {
                $num = Math::BigInt->new(1) << 63;
            }
            if ( ref $num ) {
                $num = $num->bneg;
            } else {
                $num = -1 * ~( $num - 1 );
            }
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
            # Decoded at another layer, when meaning is known.
            # At this wire-level, we only know the length, but
            # not the type (double? signed int? unsigned int?)
            $value = $consume->(8);
        } elsif ($wire_format == WIRE_FIXED32) {  # 32-bit
            # Decoded at another layer, when meaning is known.
            # At this wire-level, we only know the length, but
            # not the type (double? signed int? unsigned int?)
            $value = $consume->(4);
        } elsif ($wire_format == WIRE_START_GROUP) {  # start group
            push @evt, {
                fieldnum => $field_num,
                type => "start_group",
                wire_format => $wire_format,
            };
            $group_depth++;
            next;
        } elsif ($wire_format == WIRE_END_GROUP) {  # end group
            push @evt, {
                fieldnum => $field_num,
                type => "end_group",
                wire_format => $wire_format,
            };
            $group_depth--;
            next;
        } else {
            die "Unsupported wire format: $wire_format\n";
        }
        push @evt, {
            fieldnum => $field_num,
            value => $value,
            wire_format => $wire_format,
        };
    }

    die "Still in a group after encountering the end of the stream." if $group_depth;
    return \@evt;
}

sub decode_field_bytes {
    my ( $self, $bytes ) = @_;
    return $bytes;
}

sub decode_field_string {
    my ( $self, $string ) = @_;
    utf8::decode($string);
    return $string;
}

sub decode_field_uint32 {
    my ( $self, $int ) = @_;
    return $int;
}

sub decode_field_uint64 {
    my ( $self, $bigint ) = @_;
    if ( HAS_QUADS ){
        return $bigint;
        # FIXME two's complement if < 0
    } else {
        if ( $bigint < 0 ) {
            my $pos = $bigint & Math::BigInt->new("0xffffffffffffffff");
            return $pos;
        } else {
            return $bigint;
        }
    }
}

sub decode_field_int32 {
    my ( $self, $int ) = @_;
    return $int;
}

sub decode_field_int64 {
    my ( $self, $bigint ) = @_;
    return $bigint;
}

sub decode_field_sint32 {
    my ( $self, $int ) = @_;
    return Protobuf::WireFormat::zigzag_decode($int);
}

sub decode_field_sint64 {
    my ( $self, $bigint ) = @_;
    return Protobuf::WireFormat::zigzag_decode($bigint);
}

sub decode_field_fixed32 {
    my ( $self, $octets ) = @_;
    unpack("V", $octets);
}

sub decode_field_fixed64 {
    my ( $self, $octets ) = @_;
    Math::BigInt->new("0x", unpack("H", $octets));
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
