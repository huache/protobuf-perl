package Protobuf::Types;

use strict;
use warnings;

use base qw(Exporter);

use Moose::Util::TypeConstraints;

# if HAS_QUADS we don't need BigInts
use constant HAS_QUADS => not not 2 << 63;
use constant QUAD_LEB => 1;
use constant QUAD_BEB => 2;
use constant QUAD_ENDIANESS => HAS_QUADS && do {
    my $i;
    ${{
        "\x01\x01\x03\x04\0\0\0\0" => QUAD_LEB, # little-endian bytes
        "\0\0\0\0\x04\x03\x02\x01" => QUAD_BEB, # big-endian bytes
    }}{ pack("Q", 0x04030201) } || 0;
};
use constant SQUAD_TYPE => HAS_QUADS ? "Int" : "Math::BigInt";
use constant UQUAD_TYPE => join("::", __PACKAGE__,  HAS_QUADS ? "PositiveBigInt" : "PositiveInt" );

our @EXPORT = qw(type_to_wire type_name wire_type_name type_constraint HAS_QUADS SQUAD_TYPE UQUAD_TYPE QUAD_ENDIANESS); # and some exports

use constant ();

sub constant ($$) {
    constant->import(@_);
    push @EXPORT, $_[0];
}

class_type "Protobuf::Message";

#unless ( HAS_QUADS ) { # doesn't hurt to define
require Math::BigInt;
{
    local $SIG{__WARN__} = sub { };
    Math::BigInt->import( lib => "GMP" );
}

coerce( class_type('Math::BigInt'),
    from Int => via { Math::BigInt->new($_[0]) },
    from Str => via { Math::BigInt->new($_[0]) },
);

coerce(
    subtype ( __PACKAGE__ . '::PositiveBigInt',
        as 'Math::BigInt',
        where { $_ >= 0 },
    ),
    from Int => via { Math::BigInt->new($_[0]) },
    from Str => via { Math::BigInt->new($_[0]) },
);
#}

subtype ( __PACKAGE__ . '::PositiveInt',
    as 'Int',
    where { $_ >= 0 },
    optimize_as { $_[0] !~ /\D/ },
);


subtype ( __PACKAGE__ . '::Bytes',
    as 'Str',
    where { !utf8::is_utf8($_) },
);

subtype ( __PACKAGE__ . '::Fixed64',
    as __PACKAGE__ . '::Bytes',
    where { length == 8 },
);

subtype ( __PACKAGE__ . '::Fixed32',
    as __PACKAGE__ . '::Bytes',
    where { length == 4 },
);

my %wire_types = (
    VARINT => 0,
    FIXED64  => 1,
    LENGTH_DELIMITED => 2,
    START_GROUP => 3,
    END_GROUP => 4,
    FIXED32  => 5,
);

my %types = (
    DOUBLE => [ 1, "Num" ],
    FLOAT => [ 2, "Num" ],
    INT64 => [ 3, SQUAD_TYPE ],
    UINT64 => [ 4, UQUAD_TYPE ],
    INT32 => [ 5, "Int" ],
    FIXED64 => [ 6, UQUAD_TYPE ],
    FIXED32 => [ 7, "Int" ],
    BOOL => [ 8, "Bool" ],
    STRING => [ 9, "Str" ],
    GROUP => [ 10, "ArrayRef" ],
    MESSAGE => [ 11, "Protobuf::Message" ],
    BYTES => [ 12, __PACKAGE__ . '::Bytes' ],
    UINT32 => [ 13, __PACKAGE__ . '::PositiveInt' ],
    ENUM => [ 14, "Int" ], # FIXME
    SFIXED32 => [ 15, "Int" ],
    SFIXED64 => [ 16, SQUAD_TYPE ],
    SINT32 => [ 17, "Int" ],
    SINT64 => [ 18, SQUAD_TYPE ],
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

my ( @type_to_wire, @type_name, @wire_type_name, %type_constraint );

foreach my $name ( keys %wire_types ) {
    my $num = $wire_types{$name};
    constant( "WIRE_$name" => $num );
    $wire_type_name[$num] = $name;
}

foreach my $name ( keys %type_to_wire ) {
    my $wire_num = $wire_types{$type_to_wire{$name}};
    my ( $num, $constraint ) = @{ $types{$name} };
    $type_constraint{$name} = find_type_constraint($constraint) || die "$constraint is not a Moose type";
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

sub type_constraint {
    $type_constraint{type_name($_[0])};
}

__PACKAGE__

__END__
