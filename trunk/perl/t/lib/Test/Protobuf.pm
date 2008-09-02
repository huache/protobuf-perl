package Test::Protobuf;

use strict;
use warnings;

use base qw(Exporter);

use Test::More;
use Protobuf::Types;

our @EXPORT = qw(escaped bin_is);

sub escaped {
    my $v = shift;
    $v =~ s/([^[:print:]])/"\\x" . sprintf("%02x", ord($1))/eg if defined $v;
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
