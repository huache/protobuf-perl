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

sub encode_varbuf {
    my ( $self, $buf ) = @_;

    die "unexpected utf8 string, should be octets" if utf8::is_utf8($buf); # FIXME what's the correct behavior? at any rate length() needs to be per byte

    return ( $self->encode_varint(length($buf)) . $buf );

    # pack("W/a*")
}

__PACKAGE__

__END__
