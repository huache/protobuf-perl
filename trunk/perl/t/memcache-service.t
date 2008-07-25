#!/usr/bin/perl

use Test::More tests => 1;
use Protobuf;
use FindBin qw($Bin);
use lib "$Bin/autogen";

use_ok("Memcache");


