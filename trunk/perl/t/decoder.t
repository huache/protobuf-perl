#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 52;

use lib "t/lib";
use Test::Protobuf;
use Protobuf::Types qw(BI);

use FindBin qw($Bin);
use lib "$Bin/autogen";

no utf8;

use_ok("Protobuf::Decoder");
use Data::Dumper;
my $events;

ok($events = Protobuf::Decoder->decode("\x08\x96\x01"));
is(scalar @$events, 1);
is($events->[0]{value}, 150);
is($events->[0]{fieldnum}, 1);

ok($events = Protobuf::Decoder->decode("\x08\x80\x80\x01"));
is(scalar @$events, 1);
is($events->[0]{value}, 16384);
is($events->[0]{fieldnum}, 1);

ok($events = Protobuf::Decoder->decode("\x08\x80\x80\x80\x80\x08"));
is(scalar @$events, 1);
is($events->[0]{value}, BI(1) << 31);
is($events->[0]{fieldnum}, 1);

ok($events = Protobuf::Decoder->decode("\x08\x80\x80\x80\x80\x10"));
is(scalar @$events, 1);
is($events->[0]{value}, BI(1) << 32);
is($events->[0]{fieldnum}, 1);

ok($events = Protobuf::Decoder->decode("\x08\x80\x80\x80\x80\x80\x80\x80\x80\x80\x01"));
is(scalar @$events, 1);
is($events->[0]{value}, BI(1) << 63);
is($events->[0]{fieldnum}, 1);

ok($events = Protobuf::Decoder->decode("\x12\x07\x74\x65\x73\x74\x69\x6e\x67"));
is(scalar @$events, 1);
is($events->[0]{value}, "testing");
is($events->[0]{fieldnum}, 2);


ok( !utf8::is_utf8($events->[0]{value}), "utf8 bit is off" );

# and both tests above, together:
ok($events = Protobuf::Decoder->decode(
       "\x12\x07\x74\x65\x73\x74\x69\x6e\x67" .
       "\x08\x96\x01"));
is(scalar @$events, 2);
is($events->[0]{value}, "testing");
is($events->[0]{fieldnum}, 2);
is($events->[1]{value}, 150);
is($events->[1]{fieldnum}, 1);

# memcache get request
ok($events = Protobuf::Decoder->decode("\n\x03foo\n\x03bar"));
is(scalar @$events, 2);
is($events->[0]{value}, "foo");
is($events->[0]{fieldnum}, 1);
is($events->[1]{value}, "bar");
is($events->[1]{fieldnum}, 1);

# groups.  memcache get response.  (deprecated, but used in app engine
# because they're from proto1 originally)
ok($events = Protobuf::Decoder->decode(
       "\x0b\x12\x03foo\x1a\x0cVALUE_OF_FOO\%{\x00\x00\x00\x0c"));
is_deeply($events,
          [
           {
               'fieldnum' => 1,
               'type' => 'start_group'
           },
           {
               'value' => 'foo',
               'fieldnum' => 2,
               'wire_format' => 2,
           },
           {
               'value' => 'VALUE_OF_FOO',
               'fieldnum' => 3,
               'wire_format' => 2,
           },
           {
               'value' => "{\x00\x00\x00",
               'fieldnum' => 4,
               'wire_format' => 5,
           },
           {
               'fieldnum' => 1,
               'type' => 'end_group'
           }
          ], "MemcacheGetResponse - w/ groups");

# groups.  memcache set request.
ok($events = Protobuf::Decoder->decode(
       "\x0b\x12\x03foo\x1a\tFOO_VALUE(\x015\xff\x00\x00\x00\x0c"));
is_deeply($events, 
          [
           {
               'fieldnum' => 1,
               'type' => 'start_group'
           },
           {
               'value' => 'foo',
               'fieldnum' => 2,
               'wire_format' => 2,
           },
           {
               'value' => 'FOO_VALUE',
               'fieldnum' => 3,
               'wire_format' => 2,
           },
           {
               'value' => 1,
               'fieldnum' => 5,
               'wire_format' => 0,
           },
           {
               'value' => "\xff\x00\x00\x00",
               'fieldnum' => 6,
               'wire_format' => 5,
           },
           {
               'fieldnum' => 1,
               'type' => 'end_group'
           }
          ], "MemcacheSetRequest - w/ groups");

# MemcacheSetResponse
ok($events = Protobuf::Decoder->decode(
       "\x08\x01\x08\x02\x08\x03\x08\xfa\x01"));
is_deeply($events, 
          [
           {
             'value' => 1,
             'fieldnum' => 1,
             'wire_format' => 0,
           },
           {
             'value' => 2,
             'fieldnum' => 1,
             'wire_format' => 0,
           },
           {
             'value' => 3,
             'fieldnum' => 1,
             'wire_format' => 0,
           },
           {
             'value' => 250,
             'fieldnum' => 1,
             'wire_format' => 0,
          }
          ], "MemcacheSetResponse");

# test the decode iterator on a 1, a group (which has a subgroup), and then a 2
my $subgroup = "\x0b\x12\x03foo\x1a\tFOO_VALUE(\x015\xff\x00\x00\x00\x0c";
my $group_in_values = "\x08\x01"
    . "\x0b\x12\x03foo\x1a\tFOO_VALUE(\x015\xff\x00\x00\x00" . $subgroup . "\x0c"
    . "\x08\x02";
my $iter = Protobuf::Decoder->decode_iterator(\$group_in_values);
my $event;
$event = $iter->next;
ok($event);
is($event->{value}, 1);
$event = $iter->next;
ok($event);
is($event->{type}, "start_group");
my $subiter = $iter->subgroup_iterator;
my $n;
while ($subiter->next) { ++$n; }
is($n, 10, "10 items in subgroup");
$event = $iter->next;
ok($event);
is($event->{value}, 2);

# the end
$event = $iter->next;
ok(!$event, "hit the end");

sub dump_events {
    diag(escaped(Dumper($events)));
}

