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
    return $class->$method($value);
}

sub decode_field_sfixed32 {
    my ($class, $v) = @_;
    return unpack("l", $v);
}

sub decode_field_sfixed64 {
    my ($class, $v) = @_;
    die "assert: length not 8 bytes" unless length($v) == 8;
    my $is_neg = vec($v, 63, 1);
    # TODO(bradfitz): sick of the pack manpage... this works for now.
    my $hex = join('', sprintf("%02x"x8, reverse unpack("C16", $v)));
    my $int = Math::BigInt->new("0x$hex");
    if ($is_neg) {
        $int->bnot;
        $int->binc;
    }
    return $int;
}

sub decode_field_fixed64 {
    my ($class, $v) = @_;
    die "assert: length not 8 bytes" unless length($v) == 8;
    my $is_neg = vec($v, 63, 1);
    # TODO(bradfitz): sick of the pack manpage... this works for now.
    my $hex = join('', sprintf("%02x"x8, reverse unpack("C16", $v)));
    my $int = Math::BigInt->new("0x$hex");
    return $int;
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
    my $zd = Protobuf::WireFormat::zigzag_decode($v);
    if (UNIVERSAL::isa($zd, "Math::BigInt")) {
        return $zd->numify;
    }
    return $zd;
}

sub decode_field_sint64 {
    my ($class, $v) = @_;
    return Protobuf::WireFormat::zigzag_decode($v);
}

sub decode_field_bytes {
    my ($self, $bytes) = @_;
    return $bytes;
}

sub decode_field_string {
    my ($self, $string) = @_;
    utf8::decode($string);
    return $string;
}

sub _decode_field_no_xform_needed {
    return $_[1];
}

# The wire decoder has already converted these varints into
# unsigned integers, so we don't need to do anything:
*decode_field_uint32 = \&_decode_field_no_xform_needed;
*decode_field_uint64 = \&_decode_field_no_xform_needed;

# TODO(bradfitz): This is a lie: Enums can be negative, according to
# the Python impl at least.  So we need to fix this in the future.
# But I don't need negative enums for Perl App Engine at present.
*decode_field_enum = \&_decode_field_no_xform_needed;

my $sign_bit_64 = Math::BigInt->new("0x8000000000000000");

sub decode_field_int64 {
    my ($self, $int) = @_;
    if (UNIVERSAL::isa($int, "Math::BigInt") && ($int & $sign_bit_64)) {
        # TODO(bradfitz): pairs of bnot works too.  benchmark which is faster.
        $int->bneg;
        $int &= Math::BigInt->new("0xffffffffffffffff");
        $int->bneg;
    }
    return $int;
}

sub decode_field_int32 {
    my ($self, $int) = @_;
    if (UNIVERSAL::isa($int, "Math::BigInt")) {
        if ($int & $sign_bit_64) {
            # TODO(bradfitz): pairs of bnot works too.  benchmark which is faster.
            $int->bneg;
            $int &= Math::BigInt->new("0xffffffffffffffff");
            $int->bneg;
            $int = $int->numify;
            return $int;
        }
        # shouldn't get here, though?
        return $int->numify;
    }
    # If it was negative at all, it would've been a negative 64-bit
    # number (10 byte varint), so we know this is not a bigint and not
    # negative here:
    return $int;
}

sub decode_field_fixed32 {
    my ($self, $octets) = @_;
    return unpack("V", $octets);
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
            wire_format => $wire_format,
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
