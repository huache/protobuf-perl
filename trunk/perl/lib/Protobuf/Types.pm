package Protobuf::Types;

use strict;
use warnings;

use constant VARINT => 0;
use constant C64  => 1;
use constant STRING => 2;
use constant START_GROUP => 3;
use constant END_GROUP => 4;
use constant C32  => 5;

use base qw(Exporter);

our @EXPORT = qw(VARINT STRING C64 C32 START_GROUP END_GROUP);

__PACKAGE__

__END__
