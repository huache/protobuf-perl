package Protobuf::Types;

use strict;
use warnings;

use base qw(Exporter);

our @EXPORT = qw(type_to_wire type_name wire_type_name); # and some exports

use constant ();

sub constant ($$) {
    constant->import(@_);
    push @EXPORT, $_[0];
}

my %wire_types = (
    VARINT => 0,
    FIXED64  => 1,
    LENGTH_DELIMITED => 2,
    START_GROUP => 3,
    END_GROUP => 4,
    FIXED32  => 5,
);

my %types = (
    DOUBLE => 1,
    FLOAT => 2,
    INT64 => 3,
    UINT64 => 4,
    INT32 => 5,
    FIXED64 => 6,
    FIXED32 => 7,
    BOOL => 8,
    STRING => 9,
    GROUP => 10,
    MESSAGE => 11,
    BYTES => 12,
    UINT32 => 13,
    ENUM => 14,
    SFIXED32 => 15,
    SFIXED64 => 16,
    SINT32 => 17,
    SINT64 => 18,
);

my %wire_type_map = (
    VARINT => [qw(INT32 INT64 UINT32 UINT64 SINT32 SINT64 BOOL ENUM)],
    FIXED64 => [qw(FIXED64 SFIXED64 DOUBLE)],
    LENGTH_DELIMITED => [qw(STRING BYTES MESSAGE)],
    FIXED32 => [qw(FIXED32 SFIXED32 FLOAT)],
    START_GROUP => [qw(GROUP)],
);

my %type_to_wire = map {
    my $wire_type = $_;
    map { $_ => $wire_type } @{ $wire_type_map{$wire_type} };
} keys %wire_types;

my ( @type_to_wire, @type_name, @wire_type_name );

foreach my $name ( keys %wire_types ) {
    my $num = $wire_types{$name};
    constant( "WIRE_$name" => $num );
    $wire_type_name[$num] = $name;
}

foreach my $name ( keys %type_to_wire ) {
    my $wire_num = $wire_types{$type_to_wire{$name}};
    my $num = $types{$name};
    $type_name[$num] = $name;
    $type_to_wire[$num] = $wire_num;
    constant( "TYPE_$name"      => $num );
    constant( "WIRE_TYPE_$name" => $wire_num );
}

sub type_to_wire {
    my ( $type ) = @_;
    no warnings;
    $type_to_wire[$type] || $type_to_wire{$type};
}

sub type_name {
    no warnings;
    $type_name[$_[0]] || die "No such type $_[0]";
}

sub wire_type_name {
    $wire_type_name[$_[0]]
}

__PACKAGE__

__END__
