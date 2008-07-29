#!/usr/bin/perl

use Test::More tests => 25;

use strict;
use warnings;

use lib "t/lib";
use Test::Protobuf;

use Protobuf;
use Protobuf::Types;

use FindBin qw($Bin);
use lib "$Bin/autogen";

BEGIN { use_ok("AppEngine::Service::MemcacheProto") };

{
    my $meta = Class::MOP::Class->initialize("AppEngine::Service::MemcacheGetRequest");
    isa_ok( $meta, "Class::MOP::Class" );
    isa_ok( $meta, "Protobuf::Meta::Message" );
    isa_ok( $meta->descriptor, "Protobuf::Descriptor" );
    ok( AppEngine::Service::MemcacheGetRequest->can("meta"), "'meta' method not injected" );
}

# build up a get request
{
    my $get = AppEngine::Service::MemcacheGetRequest->new;
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
    my $getres = AppEngine::Service::MemcacheGetResponse->new;
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
    my $setreq = AppEngine::Service::MemcacheSetRequest->new;
    $it = $setreq->add_item; # creates new item and appends it
    $it->set_key("foo");
    $it->set_value("FOO_VALUE");
    $it->set_expiration_time(255);
    bin_is($setreq->serialize_to_string,
       "\x0b\x12\x03foo\x1a\tFOO_VALUE5\xff\x00\x00\x00\x0c");
    # set
    $it->set_set_policy(AppEngine::Service::MemcacheSetRequest::Item::SetPolicy::SET);
    bin_is($setreq->serialize_to_string,
       "\x0b\x12\x03foo\x1a\tFOO_VALUE(\x015\xff\x00\x00\x00\x0c");
    # add
    $it->set_set_policy(AppEngine::Service::MemcacheSetRequest::Item::SetPolicy::ADD);
    bin_is($setreq->serialize_to_string,
       "\x0b\x12\x03foo\x1a\tFOO_VALUE(\x025\xff\x00\x00\x00\x0c");
}

# build up a set response
{
    my $sres = AppEngine::Service::MemcacheSetResponse->new;
    $sres->add_set_status(1);
    $sres->add_set_status(2);
    $sres->add_set_status(3);
    $sres->add_set_status(250);
    bin_is($sres->serialize_to_string,
       "\x08\x01\x08\x02\x08\x03\x08\xfa\x01");
}

# increment response
{
    my $p = AppEngine::Service::MemcacheIncrementResponse->new;
    $p->set_new_value( BI(1) << 63 );
    bin_is($p->serialize_to_string,
       "\x08\x80\x80\x80\x80\x80\x80\x80\x80\x80\x01",
       "bigint in uint64 field");
}

# increment request
{
    my $p = AppEngine::Service::MemcacheIncrementRequest->new;
    is($p->delta, 1, "default value");
    $p->set_key("the_key");
    eval { $p->set_delta(-1) };
    ok($@);
    is($p->delta, 1, "still the default");
    $p->set_delta( BI(1) << 63);
    $p->set_direction(AppEngine::Service::MemcacheIncrementRequest::Direction::DECREMENT);
    bin_is($p->serialize_to_string,
       "\n\x07the_key\x10\x80\x80\x80\x80\x80\x80\x80\x80\x80\x01\x18\x02");
}

# stats
{
    my $p = AppEngine::Service::MemcacheStatsResponse->new;
    $p->stats;
    $p->stats->set_hits(7);
    is($p->stats->hits, 7);
    $p->stats->set_misses(8);
    $p->stats->set_oldest_item_age(257);
    ok(!defined(eval { $p->serialize_to_string; }),
       "failed to serialize with missing required fields");
    ok($@, "failed to serialize with missing required fields.");

    $p->stats->set_byte_hits(9);
    $p->stats->set_items(10);
    $p->stats->set_bytes(5);
    bin_is($p->stats->serialize_to_string,
           "\x08\x07\x10\x08\x18\t \n(\x055\x01\x01\x00\x00");
    bin_is($p->serialize_to_string,
           "\n\x0f\x08\x07\x10\x08\x18\t \n(\x055\x01\x01\x00\x00");
}
