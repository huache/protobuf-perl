package Protobuf::Types;

use strict;
use warnings;

use constant VARINT => 0;
use constant FIXED_64  => 1;
use constant BYTES => 2;
use constant START_GROUP => 3;
use constant END_GROUP => 4;
use constant FIXED_32  => 5;

use base qw(Exporter);

our @EXPORT = qw(VARINT BYTES FIXED_64 FIXED_32 START_GROUP END_GROUP);

__PACKAGE__

__END__
