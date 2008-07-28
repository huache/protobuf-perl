#!/usr/bin/perl

use Test::More tests => 19;

use strict;
use warnings;

use lib "t/lib";
use Test::Protobuf;

use Protobuf;
use FindBin qw($Bin);
use lib "$Bin/autogen";
use Math::BigInt lib => 'GMP';

BEGIN { use_ok("Memcache") };

# build up a get request
{
    my $get = MemcacheGetRequest->new;
    is($get->serialize_to_string, "");
    $get->add_key("foo");
    $get->add_key("bar");
    is($get->keys->[0], "foo");
    is($get->keys->[1], "bar");
    is($get->key_size, 2);
    bin_is($get->serialize_to_string, "\n\x03foo\n\x03bar");
}

# build up a get response
{
    my $it;
    my $getres = MemcacheGetResponse->new;
    $it = $getres->add_item; # creates new item and appends it
    $it->set_key("foo");
    $it->set_value("VALUE_OF_FOO");
    $it->set_flags(123);
    bin_is($getres->serialize_to_string,
       "\x0b\x12\x03foo\x1a\x0cVALUE_OF_FOO%{\x00\x00\x00\x0c");
}


# build up a set request
{
    my $it;
    my $setreq = MemcacheSetRequest->new;
    $it = $setreq->add_item; # creates new item and appends it
    $it->set_key("foo");
    $it->set_value("FOO_VALUE");
    $it->set_expiration_time(255);
    bin_is($setreq->serialize_to_string,
       "\x0b\x12\x03foo\x1a\tFOO_VALUE5\xff\x00\x00\x00\x0c");
    # set
    $it->set_set_policy(MemcacheSetRequest::Item::SetPolicy::SET);
    bin_is($setreq->serialize_to_string,
       "\x0b\x12\x03foo\x1a\tFOO_VALUE(\x015\xff\x00\x00\x00\x0c");
    # add
    $it->set_set_policy(MemcacheSetRequest::Item::SetPolicy::ADD);
    bin_is($setreq->serialize_to_string,
       "\x0b\x12\x03foo\x1a\tFOO_VALUE(\x025\xff\x00\x00\x00\x0c");
}

# build up a set response
{
    my $sres = MemcacheSetResponse->new;
    $sres->add_set_status(1);
    $sres->add_set_status(2);
    $sres->add_set_status(3);
    $sres->add_set_status(250);
    bin_is($sres->serialize_to_string,
       "\x08\x01\x08\x02\x08\x03\x08\xfa\x01");
}

# increment response
{
    my $p = MemcacheIncrementResponse->new;
    $p->set_new_value(Math::BigInt->new(2) ** 63);
    bin_is($p->serialize_to_string,
       "\x08\x80\x80\x80\x80\x80\x80\x80\x80\x80\x01",
       "bigint in uint64 field");
}

# increment request
{
    my $p = MemcacheIncrementRequest->new;
    is($p->delta, 1, "default value");
    $p->set_key("the_key");
    eval { $p->set_delta(-1) };
    ok($@);
    is($p->delta, 1, "still the default");
    $p->set_delta(Math::BigInt->new(2) ** 63);
    $p->set_direction(MemcacheIncrementRequest::Direction::DECREMENT);
    bin_is($p->serialize_to_string,
       "\n\x07the_key\x10\x80\x80\x80\x80\x80\x80\x80\x80\x80\x01\x18\x02");
}

# stats
{
    my $p = MemcacheStatsResponse->new;
    $p->stats;
    # FIXME coerce by default? potentially a big perf hit, unless we do a custom coercion for bigints
    $p->stats->set_hits(1);
    is($p->stats->hits, 1);
    $p->stats->set_misses(2);
    $p->stats->set_oldest_item_age(500);

    local $TODO = "required fields don't match test";

    $p->stats->set_byte_hits(3);
    $p->stats->set_items(4);
    $p->stats->set_bytes(5);
    bin_is($p->serialize_to_string,
       "\n\t\x08\x01\x10\x025\xf4\x01\x00\x00");
    bin_is($p->stats->serialize_to_string,
       "\x08\x01\x10\x025\xf4\x01\x00\x00");
}
