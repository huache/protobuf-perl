#!/usr/bin/perl

use Test::More tests => 1;
use Protobuf;
use FindBin qw($Bin);
use lib "$Bin/autogen";

use_ok("Memcache");

# build up a get request
my $get = MemcacheGetRequest->new;
is($get->serialize_to_string, "");
$get->add_key("foo");
$get->add_key("bar");
is($get->keys->[0], "foo");
is($get->keys->[1], "bar");
is($get->key_size, 2);
is($get->serialize_to_string, "\n\x03foo\n\x03bar");


