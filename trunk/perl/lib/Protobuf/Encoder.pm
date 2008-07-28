package Protobuf::Encoder;
use Moose;

use Protobuf::Types;
use utf8 ();

sub encode_wire {
    my ( $self, $field, $wire, $data ) = @_;
    my $wire_name = lc wire_type_name($wire);
    my $method = "encode_wire_${wire_name}";
    $self->$method($field, $data);
}

sub encode_field {
    my ( $self, $field, $type, $value ) = @_;
    my $type_name = lc type_name($type);
    my $method = "encode_field_${type_name}";
    $self->$method($field, $value);
}

sub encode_field_and_wire_type {
    my ( $self, $field, $wire ) = @_;
    die "bad field value, must be int" unless $field == int($field);
    die "bad wire value" unless ($wire & 7) == int($wire);
    $self->encode_varint( ( $field << 3 ) | $wire );
}

sub encode_varint {
    my ( $self, $int ) = @_;

    my $buf = '';

    die "varint must be unsigned" if $int < 0;
    die "value is not an int" unless $int == int($int); # FIXME too pedantic?

    while ( $int > 127 ) {
        $buf .= chr( ($int & 0x7f) | 0x80 );
        $int >>= 7;
    }
    return $buf . chr($int);
}

sub encode_length_delimited {
    my ( $self, $buf ) = @_;

    die "unexpected utf8 bytes, should be octets" if utf8::is_utf8($buf); # FIXME what's the correct behavior? at any rate length() needs to be per byte

    return ( $self->encode_varint(length($buf)) . $buf );

    # pack("W/a*")
}

sub encode_wire_fixed32 {
    my ( $self, $field, $buf ) = @_;
    die "value must be a 4 octet byte" if utf8::is_utf8($buf) || length($buf) != 4;
    $self->encode_field_and_wire_type($field, WIRE_FIXED32) . $buf;
}

sub encode_wire_fixed64 {
    my ( $self, $field, $buf ) = @_;
    die "value must be an 8 octet byte" if utf8::is_utf8($buf) || length($buf) != 8;
    $self->encode_field_and_wire_type($field, WIRE_FIXED64) . $buf;
}

sub encode_wire_varint {
    my ( $self, $field, $int ) = @_;
    $self->encode_field_and_wire_type($field, WIRE_VARINT) . $self->encode_varint($int);
}

sub encode_wire_length_delimited {
    my ( $self, $field, $bytes ) = @_;
    $self->encode_field_and_wire_type($field, WIRE_LENGTH_DELIMITED) . $self->encode_length_delimited($bytes);
}

sub encode_wire_start_group {
    my ( $self, $field ) = @_;
    $self->encode_field_and_wire_type($field, WIRE_START_GROUP);
}

sub encode_wire_end_group {
    my ( $self, $field ) = @_;
    $self->encode_field_and_wire_type($field, WIRE_END_GROUP);
}




sub encode_field_bytes {
    my ( $self, $field, $bytes ) = @_;
    $self->encode_wire_length_delimited($field, $bytes);
}

sub encode_field_string {
    my ( $self, $field, $string ) = @_;
    utf8::decode($string);
    $self->encode_wire_length_delimited($field, $string);
}

sub encode_field_message {
    my ( $self, $field, $item ) = @_;
    $self->encode_wire_length_delimited($field, $item->serialize_to_string);
}

sub encode_field_group {
    my ( $self, $field, @items ) = @_;

    join('',
        $self->encode_wire_start_group($field),
        ( map { $_->serialize_to_string } @items ),
        $self->encode_wire_end_group($field),
    );
}

sub encode_field_fixed32 {
    my ( $self, $field, $int ) = @_;
    $self->encode_wire_fixed32($field, pack("V", $int));
}

sub encode_field_enum {
    my ( $self, $field, $int ) = @_;
    $self->encode_wire_varint($field, $int);
}

sub encode_field_uint64 {
    my ( $self, $field, $bigint ) = @_;
    $self->encode_wire_varint($field, $bigint);
}

sub encode_field_fixed64 {
    my ( $self, $field, $bigint ) = @_;
    my $bin;
    if ( HAS_QUADS ) {
        if ( QUAD_ENDIANESS == QUAD_LEB ) {
            $bin = pack("Q", $bigint);
        } elsif ( QUAD_ENDIANESS == QUAD_BEB ) {
            $bin = reverse(pack("Q", $bigint));
        } else {
            die "endianess unknown";
        }
    } else {
        my $hex = $bigint->as_hex;
        $bin = reverse pack('H16', substr($hex, 2));
    }

    $self->encode_wire_fixed64( $field, $bin );
}

__PACKAGE__->meta->make_immutable;

__PACKAGE__

__END__
