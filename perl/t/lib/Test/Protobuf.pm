package Test::Protobuf;

use strict;
use warnings;

use base qw(Exporter);

use Test::More;
use Protobuf::Types;

our @EXPORT = qw(escaped bin_is BI);

sub BI {
    my $v = $_[0];
    if ( HAS_QUADS ) {
        return 0+$v if $v !~ /\D/;
        if ( $v =~ /^0x/ ) {
            my ( $high, $low ) = unpack("NN", pack("H*", substr($v,2)));
            return ( $high << 32 | $low );
        } else {
            die "unknown number format: $v";
        }
    } else {
        return Math::BigInt->new($_[0]);
    }
}

sub escaped {
    my $v = shift;
    $v =~ s/([^[:print:]])/"\\x" . sprintf("%02x", ord($1))/eg;
    return $v;
}

sub bin_is ($$;$) {
    my @args = @_;
    foreach my $buf ( @args[0,1] ) { # copy because of readonly assignment
        fail("found utf8 data") if utf8::is_utf8($buf);
        $buf = escaped($buf);
    }

    @_ = @args;
    goto \&is;
}


__PACKAGE__

__END__
