#!/usr/bin/perl

use Test::More tests => 24;
use FindBin qw($Bin);
use lib "$Bin/autogen";

use_ok("Protobuf::Decoder");
use Data::Dumper;
my $events;

ok($events = Protobuf::Decoder->decode("\x08\x96\x01"));
is(scalar @$events, 1);
is($events->[0]{value}, 150);
is($events->[0]{fieldnum}, 1);

ok($events = Protobuf::Decoder->decode("\x12\x07\x74\x65\x73\x74\x69\x6e\x67"));
is(scalar @$events, 1);
is($events->[0]{value}, "testing");
is($events->[0]{fieldnum}, 2);

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
       "\x0b\x12\x03foo\x1a\x0cVALUE_OF_FOO%{\x00\x00\x00\x0c"));
diag(escaped(Dumper($events)));

# groups.  memcache set request.
ok($events = Protobuf::Decoder->decode(
       "\x0b\x12\x03foo\x1a\tFOO_VALUE(\x015\xff\x00\x00\x00\x0c"));
diag(escaped(Dumper($events)));

# MemcacheSetResponse
ok($events = Protobuf::Decoder->decode(
       "\x08\x01\x08\x02\x08\x03\x08\xfa\x01"));
diag(escaped(Dumper($events)));

sub escaped {
    my $v = shift;
    $v =~ s/([^[:print:]\n])/"\\x" . sprintf("%02x", ord($1))/eg;
    return $v;
}

