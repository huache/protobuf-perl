#!/usr/bin/perl

use Test::More tests => 15;
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

diag(escaped(Dumper($events)));


sub escaped {
    my $v = shift;
    $v =~ s/([^[:print:]\n])/"\\x" . sprintf("%02x", ord($1))/eg;
    return $v;
}

