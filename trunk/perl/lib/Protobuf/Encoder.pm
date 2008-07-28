package Protobuf::Encoder;
use Moose;

sub encode_field_and_wire {
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

sub encode_string {
    my ( $self, $buf ) = @_;

    die "unexpected utf8 string, should be octets" if utf8::is_utf8($buf); # FIXME what's the correct behavior? at any rate length() needs to be per byte

    return ( $self->encode_varint(length($buf)) . $buf );

    # pack("W/a*")
}

sub encode_4_byte_field {
    my ( $self, $field, $buf ) = @_;
    die "value must be a 4 octet string" if utf8::is_utf8($buf) || length($buf) != 4;
    $self->encode_field_and_wire($field, 5) . $buf;
}

sub encode_8_byte_field {
    my ( $self, $field, $buf ) = @_;
    die "value must be an 8 octet string" if utf8::is_utf8($buf) || length($buf) != 8;
    $self->encode_field_and_wire($field, 1) . $buf;
}

sub encode_varint_field {
    my ( $self, $field, $int ) = @_;
    $self->encode_field_and_wire($field, 0) . $self->encode_varint($int);
}

sub encode_string_field {
    my ( $self, $field, $string ) = @_;
    $self->encode_field_and_wire($field, 2) . $self->encode_string($string);
}

sub encode_start_group {
    my ( $self, $field ) = @_;
    $self->encode_field_and_wire($field, 3);
}

sub encode_end_group {
    my ( $self, $field ) = @_;
    $self->encode_field_and_wire($field, 4);
}

__PACKAGE__

__END__
