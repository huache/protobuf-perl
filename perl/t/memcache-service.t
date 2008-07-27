#!/usr/bin/perl

use Test::More tests => 1;
use Protobuf;
use FindBin qw($Bin);
use lib "$Bin/autogen";

use_ok("Memcache");

# build up a get request
{
    my $get = MemcacheGetRequest->new;
    is($get->serialize_to_string, "");
    $get->add_key("foo");
    $get->add_key("bar");
    is($get->keys->[0], "foo");
    is($get->keys->[1], "bar");
    is($get->key_size, 2);
    is($get->serialize_to_string, "\n\x03foo\n\x03bar");
}

# build up a get response
{
    my $it;
    my $getres = MemcacheGetResponse->new;
    $it = $getres->add_item; # creates new item and appends it
    $it->set_key("foo");
    $it->set_value("VALUE_OF_FOO");
    $it->set_flags(123);
    is($getres->serialize_to_string,
       "\x0b\x12\x03foo\x1a\x0cVALUE_OF_FOO%{\x00\x00\x00\x0c");
}


