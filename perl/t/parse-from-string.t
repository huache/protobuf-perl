#!/usr/bin/perl

use Test::More 'no_plan';

use strict;
use warnings;

use lib "t/lib";
use Test::Protobuf;

use Protobuf;
use Protobuf::Types;

use FindBin qw($Bin);
use lib "$Bin/autogen";

BEGIN { use_ok("AppEngine::Service::MemcacheProto") };

# scalar non-aggregates (e.g. "required string" or "optional int32")
{
    my $i1 = AppEngine::Service::MemcacheGetResponse::Item->new;
    $i1->set_key("key1");
    $i1->set_value("value1");
    $i1->set_flags(123);

    # get a single field
    $i1->merge_from_string("\x12\x05key_b");
    is($i1->key, "key_b", "i1 got new key");
    is($i1->value, "value1", "i1 got new key");

    my $i2 = AppEngine::Service::MemcacheGetResponse::Item->new;
    $i2->set_key("key2");
    $i2->set_value("value2");

    $i1->merge_from_string($i2->serialize_to_string);
    is($i1->key, "key2", "i1 got i2's key");
    is($i1->value, "value2", "i1 got i2's value");
    is($i1->flags, 123, "i1 still has its own flags");
}

# repeated non-aggregates (e.g. "repeated string" or "repeated int32")
{
    my $get = AppEngine::Service::MemcacheGetRequest->new;
    is($get->serialize_to_string, "");
    $get->add_key("foo");
    $get->add_key("bar");
    is($get->keys->[0], "foo");
    is($get->keys->[1], "bar");
    is($get->key_size, 2);
    bin_is($get->serialize_to_string, "\n\x03foo\n\x03bar");

    my $get2 = AppEngine::Service::MemcacheGetRequest->new;

    # add a foo
    $get2->add_key("foo");
    bin_is($get2->serialize_to_string, "\n\x03foo", "just a foo");

    # kill it.
    $get2->clear;
    bin_is($get2->serialize_to_string, "", "is cleared");

    # add it back.
    $get2->add_key("foo");

    # and append a bar.  (foo should still be there)
    $get2->merge_from_string("\n\x03bar");
    is($get2->key_size, 2);
    is($get2->keys->[0], "foo");
    is($get2->keys->[1], "bar");

    # but this should clear it and set it to just bar
    $get2->parse_from_string("\n\x03bar");
    is($get2->key_size, 1);
    is($get2->keys->[0], "bar");

    # round-trips:
    $get2->parse_from_string($get->serialize_to_string);
    bin_is($get2->serialize_to_string, $get->serialize_to_string, "round-trips");
}

