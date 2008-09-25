## Boilerplate:
# Auto-generated code from the protocol buffer compiler.  DO NOT EDIT!

use strict;
use warnings;
use 5.6.1;
use Protobuf;
use Protobuf::Types;

package ProtobufTestBasic;


use constant TRUE => 1;
use constant FALSE => 0;
## Top-level enums:
our $_FOREIGNENUM = Protobuf::EnumDescriptor->new(
  name => 'ForeignEnum',
  full_name => 'ProtobufTestBasic::ForeignEnum',
  values => [
    Protobuf::EnumValueDescriptor->new(name => 'FOREIGN_FOO', index => 0, number => 4, type => undef),
    Protobuf::EnumValueDescriptor->new(name => 'FOREIGN_BAR', index => 1, number => 5, type => undef),
    Protobuf::EnumValueDescriptor->new(name => 'FOREIGN_BAZ', index => 2, number => 6, type => undef),
]);
$_FOREIGNENUM->values->[0]->set_type($_FOREIGNENUM);
$_FOREIGNENUM->values->[1]->set_type($_FOREIGNENUM);
$_FOREIGNENUM->values->[2]->set_type($_FOREIGNENUM);


our $_TESTENUMWITHDUPVALUE = Protobuf::EnumDescriptor->new(
  name => 'TestEnumWithDupValue',
  full_name => 'ProtobufTestBasic::TestEnumWithDupValue',
  values => [
    Protobuf::EnumValueDescriptor->new(name => 'FOO1', index => 0, number => 1, type => undef),
    Protobuf::EnumValueDescriptor->new(name => 'BAR1', index => 1, number => 2, type => undef),
    Protobuf::EnumValueDescriptor->new(name => 'BAZ', index => 2, number => 3, type => undef),
    Protobuf::EnumValueDescriptor->new(name => 'FOO2', index => 3, number => 1, type => undef),
    Protobuf::EnumValueDescriptor->new(name => 'BAR2', index => 4, number => 2, type => undef),
]);
$_TESTENUMWITHDUPVALUE->values->[0]->set_type($_TESTENUMWITHDUPVALUE);
$_TESTENUMWITHDUPVALUE->values->[1]->set_type($_TESTENUMWITHDUPVALUE);
$_TESTENUMWITHDUPVALUE->values->[2]->set_type($_TESTENUMWITHDUPVALUE);
$_TESTENUMWITHDUPVALUE->values->[3]->set_type($_TESTENUMWITHDUPVALUE);
$_TESTENUMWITHDUPVALUE->values->[4]->set_type($_TESTENUMWITHDUPVALUE);


our $_TESTSPARSEENUM = Protobuf::EnumDescriptor->new(
  name => 'TestSparseEnum',
  full_name => 'ProtobufTestBasic::TestSparseEnum',
  values => [
    Protobuf::EnumValueDescriptor->new(name => 'SPARSE_A', index => 0, number => 123, type => undef),
    Protobuf::EnumValueDescriptor->new(name => 'SPARSE_B', index => 1, number => 62374, type => undef),
    Protobuf::EnumValueDescriptor->new(name => 'SPARSE_C', index => 2, number => 12589234, type => undef),
    Protobuf::EnumValueDescriptor->new(name => 'SPARSE_D', index => 3, number => -15, type => undef),
    Protobuf::EnumValueDescriptor->new(name => 'SPARSE_E', index => 4, number => -53452, type => undef),
    Protobuf::EnumValueDescriptor->new(name => 'SPARSE_F', index => 5, number => 0, type => undef),
    Protobuf::EnumValueDescriptor->new(name => 'SPARSE_G', index => 6, number => 2, type => undef),
]);
$_TESTSPARSEENUM->values->[0]->set_type($_TESTSPARSEENUM);
$_TESTSPARSEENUM->values->[1]->set_type($_TESTSPARSEENUM);
$_TESTSPARSEENUM->values->[2]->set_type($_TESTSPARSEENUM);
$_TESTSPARSEENUM->values->[3]->set_type($_TESTSPARSEENUM);
$_TESTSPARSEENUM->values->[4]->set_type($_TESTSPARSEENUM);
$_TESTSPARSEENUM->values->[5]->set_type($_TESTSPARSEENUM);
$_TESTSPARSEENUM->values->[6]->set_type($_TESTSPARSEENUM);


## Top-level extensions:

## All nested enums:
our $_TESTALLTYPES_NESTEDENUM = Protobuf::EnumDescriptor->new(
  name => 'NestedEnum',
  full_name => 'ProtobufTestBasic::NestedEnum',
  values => [
    Protobuf::EnumValueDescriptor->new(name => 'FOO', index => 0, number => 1, type => undef),
    Protobuf::EnumValueDescriptor->new(name => 'BAR', index => 1, number => 2, type => undef),
    Protobuf::EnumValueDescriptor->new(name => 'BAZ', index => 2, number => 3, type => undef),
]);
$_TESTALLTYPES_NESTEDENUM->values->[0]->set_type($_TESTALLTYPES_NESTEDENUM);
$_TESTALLTYPES_NESTEDENUM->values->[1]->set_type($_TESTALLTYPES_NESTEDENUM);
$_TESTALLTYPES_NESTEDENUM->values->[2]->set_type($_TESTALLTYPES_NESTEDENUM);

## Message descriptors:

our $_TESTALLTYPES_NESTEDMESSAGE = Protobuf::Descriptor->new(
  name => 'NestedMessage',
  full_name => 'ProtobufTestBasic::TestAllTypes.NestedMessage',
  containing_type => undef,
  fields => [
    Protobuf::FieldDescriptor->new(
      name => 'bb', index => 0, number => 1,
      type => 5, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
  ],
  extensions => [
  ],
  nested_types => [],  # TODO(bradfitz): Implement.
  enum_types => [
  ],
  options => Protobuf::MessageOptions->new(
  ),
);

our $_TESTALLTYPES_OPTIONALGROUP = Protobuf::Descriptor->new(
  name => 'OptionalGroup',
  full_name => 'ProtobufTestBasic::TestAllTypes.OptionalGroup',
  containing_type => undef,
  fields => [
    Protobuf::FieldDescriptor->new(
      name => 'a', index => 0, number => 17,
      type => 5, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
  ],
  extensions => [
  ],
  nested_types => [],  # TODO(bradfitz): Implement.
  enum_types => [
  ],
  options => Protobuf::MessageOptions->new(
  ),
);

our $_TESTALLTYPES_REPEATEDGROUP = Protobuf::Descriptor->new(
  name => 'RepeatedGroup',
  full_name => 'ProtobufTestBasic::TestAllTypes.RepeatedGroup',
  containing_type => undef,
  fields => [
    Protobuf::FieldDescriptor->new(
      name => 'a', index => 0, number => 47,
      type => 5, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
  ],
  extensions => [
  ],
  nested_types => [],  # TODO(bradfitz): Implement.
  enum_types => [
  ],
  options => Protobuf::MessageOptions->new(
  ),
);

our $_TESTALLTYPES = Protobuf::Descriptor->new(
  name => 'TestAllTypes',
  full_name => 'ProtobufTestBasic::TestAllTypes',
  containing_type => undef,
  fields => [
    Protobuf::FieldDescriptor->new(
      name => 'optional_int32', index => 0, number => 1,
      type => 5, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'optional_int64', index => 1, number => 2,
      type => 3, cpp_type => 2, label => 1,
      default_value => Protobuf::Types::BI("0"),
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'optional_uint32', index => 2, number => 3,
      type => 13, cpp_type => 3, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'optional_uint64', index => 3, number => 4,
      type => 4, cpp_type => 4, label => 1,
      default_value => Protobuf::Types::BI("0"),
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'optional_sint32', index => 4, number => 5,
      type => 17, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'optional_sint64', index => 5, number => 6,
      type => 18, cpp_type => 2, label => 1,
      default_value => Protobuf::Types::BI("0"),
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'optional_fixed32', index => 6, number => 7,
      type => 7, cpp_type => 3, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'optional_fixed64', index => 7, number => 8,
      type => 6, cpp_type => 4, label => 1,
      default_value => Protobuf::Types::BI("0"),
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'optional_sfixed32', index => 8, number => 9,
      type => 15, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'optional_sfixed64', index => 9, number => 10,
      type => 16, cpp_type => 2, label => 1,
      default_value => Protobuf::Types::BI("0"),
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'optional_float', index => 10, number => 11,
      type => 2, cpp_type => 6, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'optional_double', index => 11, number => 12,
      type => 1, cpp_type => 5, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'optional_bool', index => 12, number => 13,
      type => 8, cpp_type => 7, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'optional_string', index => 13, number => 14,
      type => 9, cpp_type => 9, label => 1,
      default_value => "",
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'optional_bytes', index => 14, number => 15,
      type => 12, cpp_type => 9, label => 1,
      default_value => "",
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'optionalgroup', index => 15, number => 16,
      type => 10, cpp_type => 10, label => 1,
      default_value => undef,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'optional_nested_message', index => 16, number => 18,
      type => 11, cpp_type => 10, label => 1,
      default_value => undef,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'optional_foreign_message', index => 17, number => 19,
      type => 11, cpp_type => 10, label => 1,
      default_value => undef,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'optional_nested_enum', index => 18, number => 21,
      type => 14, cpp_type => 8, label => 1,
      default_value => 1,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'optional_foreign_enum', index => 19, number => 22,
      type => 14, cpp_type => 8, label => 1,
      default_value => 4,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'optional_string_piece', index => 20, number => 24,
      type => 9, cpp_type => 9, label => 1,
      default_value => "",
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'optional_cord', index => 21, number => 25,
      type => 9, cpp_type => 9, label => 1,
      default_value => "",
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'repeated_int32', index => 22, number => 31,
      type => 5, cpp_type => 1, label => 3,
      default_value => [],
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'repeated_int64', index => 23, number => 32,
      type => 3, cpp_type => 2, label => 3,
      default_value => [],
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'repeated_uint32', index => 24, number => 33,
      type => 13, cpp_type => 3, label => 3,
      default_value => [],
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'repeated_uint64', index => 25, number => 34,
      type => 4, cpp_type => 4, label => 3,
      default_value => [],
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'repeated_sint32', index => 26, number => 35,
      type => 17, cpp_type => 1, label => 3,
      default_value => [],
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'repeated_sint64', index => 27, number => 36,
      type => 18, cpp_type => 2, label => 3,
      default_value => [],
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'repeated_fixed32', index => 28, number => 37,
      type => 7, cpp_type => 3, label => 3,
      default_value => [],
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'repeated_fixed64', index => 29, number => 38,
      type => 6, cpp_type => 4, label => 3,
      default_value => [],
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'repeated_sfixed32', index => 30, number => 39,
      type => 15, cpp_type => 1, label => 3,
      default_value => [],
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'repeated_sfixed64', index => 31, number => 40,
      type => 16, cpp_type => 2, label => 3,
      default_value => [],
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'repeated_float', index => 32, number => 41,
      type => 2, cpp_type => 6, label => 3,
      default_value => [],
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'repeated_double', index => 33, number => 42,
      type => 1, cpp_type => 5, label => 3,
      default_value => [],
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'repeated_bool', index => 34, number => 43,
      type => 8, cpp_type => 7, label => 3,
      default_value => [],
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'repeated_string', index => 35, number => 44,
      type => 9, cpp_type => 9, label => 3,
      default_value => [],
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'repeated_bytes', index => 36, number => 45,
      type => 12, cpp_type => 9, label => 3,
      default_value => [],
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'repeatedgroup', index => 37, number => 46,
      type => 10, cpp_type => 10, label => 3,
      default_value => [],
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'repeated_nested_message', index => 38, number => 48,
      type => 11, cpp_type => 10, label => 3,
      default_value => [],
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'repeated_foreign_message', index => 39, number => 49,
      type => 11, cpp_type => 10, label => 3,
      default_value => [],
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'repeated_nested_enum', index => 40, number => 51,
      type => 14, cpp_type => 8, label => 3,
      default_value => [],
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'repeated_foreign_enum', index => 41, number => 52,
      type => 14, cpp_type => 8, label => 3,
      default_value => [],
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'repeated_string_piece', index => 42, number => 54,
      type => 9, cpp_type => 9, label => 3,
      default_value => [],
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'repeated_cord', index => 43, number => 55,
      type => 9, cpp_type => 9, label => 3,
      default_value => [],
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'default_int32', index => 44, number => 61,
      type => 5, cpp_type => 1, label => 1,
      default_value => 41,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'default_int64', index => 45, number => 62,
      type => 3, cpp_type => 2, label => 1,
      default_value => Protobuf::Types::BI("42"),
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'default_uint32', index => 46, number => 63,
      type => 13, cpp_type => 3, label => 1,
      default_value => 43,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'default_uint64', index => 47, number => 64,
      type => 4, cpp_type => 4, label => 1,
      default_value => Protobuf::Types::BI("44"),
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'default_sint32', index => 48, number => 65,
      type => 17, cpp_type => 1, label => 1,
      default_value => -45,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'default_sint64', index => 49, number => 66,
      type => 18, cpp_type => 2, label => 1,
      default_value => Protobuf::Types::BI("46"),
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'default_fixed32', index => 50, number => 67,
      type => 7, cpp_type => 3, label => 1,
      default_value => 47,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'default_fixed64', index => 51, number => 68,
      type => 6, cpp_type => 4, label => 1,
      default_value => Protobuf::Types::BI("48"),
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'default_sfixed32', index => 52, number => 69,
      type => 15, cpp_type => 1, label => 1,
      default_value => 49,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'default_sfixed64', index => 53, number => 70,
      type => 16, cpp_type => 2, label => 1,
      default_value => Protobuf::Types::BI("-50"),
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'default_float', index => 54, number => 71,
      type => 2, cpp_type => 6, label => 1,
      default_value => 51.5,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'default_double', index => 55, number => 72,
      type => 1, cpp_type => 5, label => 1,
      default_value => 52000,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'default_bool', index => 56, number => 73,
      type => 8, cpp_type => 7, label => 1,
      default_value => 1,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'default_string', index => 57, number => 74,
      type => 9, cpp_type => 9, label => 1,
      default_value => "hello",
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'default_bytes', index => 58, number => 75,
      type => 12, cpp_type => 9, label => 1,
      default_value => "world",
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'default_nested_enum', index => 59, number => 81,
      type => 14, cpp_type => 8, label => 1,
      default_value => 2,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'default_foreign_enum', index => 60, number => 82,
      type => 14, cpp_type => 8, label => 1,
      default_value => 5,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'default_string_piece', index => 61, number => 84,
      type => 9, cpp_type => 9, label => 1,
      default_value => "abc",
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'default_cord', index => 62, number => 85,
      type => 9, cpp_type => 9, label => 1,
      default_value => "123",
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
  ],
  extensions => [
  ],
  nested_types => [],  # TODO(bradfitz): Implement.
  enum_types => [
    $_TESTALLTYPES_NESTEDENUM,
  ],
  options => Protobuf::MessageOptions->new(
  ),
);


our $_FOREIGNMESSAGE = Protobuf::Descriptor->new(
  name => 'ForeignMessage',
  full_name => 'ProtobufTestBasic::ForeignMessage',
  containing_type => undef,
  fields => [
    Protobuf::FieldDescriptor->new(
      name => 'c', index => 0, number => 1,
      type => 5, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
  ],
  extensions => [
  ],
  nested_types => [],  # TODO(bradfitz): Implement.
  enum_types => [
  ],
  options => Protobuf::MessageOptions->new(
  ),
);


our $_TESTREQUIRED = Protobuf::Descriptor->new(
  name => 'TestRequired',
  full_name => 'ProtobufTestBasic::TestRequired',
  containing_type => undef,
  fields => [
    Protobuf::FieldDescriptor->new(
      name => 'a', index => 0, number => 1,
      type => 5, cpp_type => 1, label => 2,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'dummy2', index => 1, number => 2,
      type => 5, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'b', index => 2, number => 3,
      type => 5, cpp_type => 1, label => 2,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'dummy4', index => 3, number => 4,
      type => 5, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'dummy5', index => 4, number => 5,
      type => 5, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'dummy6', index => 5, number => 6,
      type => 5, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'dummy7', index => 6, number => 7,
      type => 5, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'dummy8', index => 7, number => 8,
      type => 5, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'dummy9', index => 8, number => 9,
      type => 5, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'dummy10', index => 9, number => 10,
      type => 5, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'dummy11', index => 10, number => 11,
      type => 5, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'dummy12', index => 11, number => 12,
      type => 5, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'dummy13', index => 12, number => 13,
      type => 5, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'dummy14', index => 13, number => 14,
      type => 5, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'dummy15', index => 14, number => 15,
      type => 5, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'dummy16', index => 15, number => 16,
      type => 5, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'dummy17', index => 16, number => 17,
      type => 5, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'dummy18', index => 17, number => 18,
      type => 5, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'dummy19', index => 18, number => 19,
      type => 5, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'dummy20', index => 19, number => 20,
      type => 5, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'dummy21', index => 20, number => 21,
      type => 5, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'dummy22', index => 21, number => 22,
      type => 5, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'dummy23', index => 22, number => 23,
      type => 5, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'dummy24', index => 23, number => 24,
      type => 5, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'dummy25', index => 24, number => 25,
      type => 5, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'dummy26', index => 25, number => 26,
      type => 5, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'dummy27', index => 26, number => 27,
      type => 5, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'dummy28', index => 27, number => 28,
      type => 5, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'dummy29', index => 28, number => 29,
      type => 5, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'dummy30', index => 29, number => 30,
      type => 5, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'dummy31', index => 30, number => 31,
      type => 5, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'dummy32', index => 31, number => 32,
      type => 5, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'c', index => 32, number => 33,
      type => 5, cpp_type => 1, label => 2,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
  ],
  extensions => [
  ],
  nested_types => [],  # TODO(bradfitz): Implement.
  enum_types => [
  ],
  options => Protobuf::MessageOptions->new(
  ),
);


our $_TESTREQUIREDFOREIGN = Protobuf::Descriptor->new(
  name => 'TestRequiredForeign',
  full_name => 'ProtobufTestBasic::TestRequiredForeign',
  containing_type => undef,
  fields => [
    Protobuf::FieldDescriptor->new(
      name => 'optional_message', index => 0, number => 1,
      type => 11, cpp_type => 10, label => 1,
      default_value => undef,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'repeated_message', index => 1, number => 2,
      type => 11, cpp_type => 10, label => 3,
      default_value => [],
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'dummy', index => 2, number => 3,
      type => 5, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
  ],
  extensions => [
  ],
  nested_types => [],  # TODO(bradfitz): Implement.
  enum_types => [
  ],
  options => Protobuf::MessageOptions->new(
  ),
);


our $_TESTFOREIGNNESTED = Protobuf::Descriptor->new(
  name => 'TestForeignNested',
  full_name => 'ProtobufTestBasic::TestForeignNested',
  containing_type => undef,
  fields => [
    Protobuf::FieldDescriptor->new(
      name => 'foreign_nested', index => 0, number => 1,
      type => 11, cpp_type => 10, label => 1,
      default_value => undef,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
  ],
  extensions => [
  ],
  nested_types => [],  # TODO(bradfitz): Implement.
  enum_types => [
  ],
  options => Protobuf::MessageOptions->new(
  ),
);


our $_TESTEMPTYMESSAGE = Protobuf::Descriptor->new(
  name => 'TestEmptyMessage',
  full_name => 'ProtobufTestBasic::TestEmptyMessage',
  containing_type => undef,
  fields => [
  ],
  extensions => [
  ],
  nested_types => [],  # TODO(bradfitz): Implement.
  enum_types => [
  ],
  options => Protobuf::MessageOptions->new(
  ),
);


our $_TESTREALLYLARGETAGNUMBER = Protobuf::Descriptor->new(
  name => 'TestReallyLargeTagNumber',
  full_name => 'ProtobufTestBasic::TestReallyLargeTagNumber',
  containing_type => undef,
  fields => [
    Protobuf::FieldDescriptor->new(
      name => 'a', index => 0, number => 1,
      type => 5, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'bb', index => 1, number => 268435455,
      type => 5, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
  ],
  extensions => [
  ],
  nested_types => [],  # TODO(bradfitz): Implement.
  enum_types => [
  ],
  options => Protobuf::MessageOptions->new(
  ),
);


our $_TESTRECURSIVEMESSAGE = Protobuf::Descriptor->new(
  name => 'TestRecursiveMessage',
  full_name => 'ProtobufTestBasic::TestRecursiveMessage',
  containing_type => undef,
  fields => [
    Protobuf::FieldDescriptor->new(
      name => 'a', index => 0, number => 1,
      type => 11, cpp_type => 10, label => 1,
      default_value => undef,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'i', index => 1, number => 2,
      type => 5, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
  ],
  extensions => [
  ],
  nested_types => [],  # TODO(bradfitz): Implement.
  enum_types => [
  ],
  options => Protobuf::MessageOptions->new(
  ),
);


our $_TESTMUTUALRECURSIONA = Protobuf::Descriptor->new(
  name => 'TestMutualRecursionA',
  full_name => 'ProtobufTestBasic::TestMutualRecursionA',
  containing_type => undef,
  fields => [
    Protobuf::FieldDescriptor->new(
      name => 'bb', index => 0, number => 1,
      type => 11, cpp_type => 10, label => 1,
      default_value => undef,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
  ],
  extensions => [
  ],
  nested_types => [],  # TODO(bradfitz): Implement.
  enum_types => [
  ],
  options => Protobuf::MessageOptions->new(
  ),
);


our $_TESTMUTUALRECURSIONB = Protobuf::Descriptor->new(
  name => 'TestMutualRecursionB',
  full_name => 'ProtobufTestBasic::TestMutualRecursionB',
  containing_type => undef,
  fields => [
    Protobuf::FieldDescriptor->new(
      name => 'a', index => 0, number => 1,
      type => 11, cpp_type => 10, label => 1,
      default_value => undef,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'optional_int32', index => 1, number => 2,
      type => 5, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
  ],
  extensions => [
  ],
  nested_types => [],  # TODO(bradfitz): Implement.
  enum_types => [
  ],
  options => Protobuf::MessageOptions->new(
  ),
);


our $_TESTDUPFIELDNUMBER_FOO = Protobuf::Descriptor->new(
  name => 'Foo',
  full_name => 'ProtobufTestBasic::TestDupFieldNumber.Foo',
  containing_type => undef,
  fields => [
    Protobuf::FieldDescriptor->new(
      name => 'a', index => 0, number => 1,
      type => 5, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
  ],
  extensions => [
  ],
  nested_types => [],  # TODO(bradfitz): Implement.
  enum_types => [
  ],
  options => Protobuf::MessageOptions->new(
  ),
);

our $_TESTDUPFIELDNUMBER_BAR = Protobuf::Descriptor->new(
  name => 'Bar',
  full_name => 'ProtobufTestBasic::TestDupFieldNumber.Bar',
  containing_type => undef,
  fields => [
    Protobuf::FieldDescriptor->new(
      name => 'a', index => 0, number => 1,
      type => 5, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
  ],
  extensions => [
  ],
  nested_types => [],  # TODO(bradfitz): Implement.
  enum_types => [
  ],
  options => Protobuf::MessageOptions->new(
  ),
);

our $_TESTDUPFIELDNUMBER = Protobuf::Descriptor->new(
  name => 'TestDupFieldNumber',
  full_name => 'ProtobufTestBasic::TestDupFieldNumber',
  containing_type => undef,
  fields => [
    Protobuf::FieldDescriptor->new(
      name => 'a', index => 0, number => 1,
      type => 5, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'foo', index => 1, number => 2,
      type => 10, cpp_type => 10, label => 1,
      default_value => undef,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'bar', index => 2, number => 3,
      type => 10, cpp_type => 10, label => 1,
      default_value => undef,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
  ],
  extensions => [
  ],
  nested_types => [],  # TODO(bradfitz): Implement.
  enum_types => [
  ],
  options => Protobuf::MessageOptions->new(
  ),
);


our $_TESTNESTEDMESSAGEHASBITS_NESTEDMESSAGE = Protobuf::Descriptor->new(
  name => 'NestedMessage',
  full_name => 'ProtobufTestBasic::TestNestedMessageHasBits.NestedMessage',
  containing_type => undef,
  fields => [
    Protobuf::FieldDescriptor->new(
      name => 'nestedmessage_repeated_int32', index => 0, number => 1,
      type => 5, cpp_type => 1, label => 3,
      default_value => [],
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'nestedmessage_repeated_foreignmessage', index => 1, number => 2,
      type => 11, cpp_type => 10, label => 3,
      default_value => [],
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
  ],
  extensions => [
  ],
  nested_types => [],  # TODO(bradfitz): Implement.
  enum_types => [
  ],
  options => Protobuf::MessageOptions->new(
  ),
);

our $_TESTNESTEDMESSAGEHASBITS = Protobuf::Descriptor->new(
  name => 'TestNestedMessageHasBits',
  full_name => 'ProtobufTestBasic::TestNestedMessageHasBits',
  containing_type => undef,
  fields => [
    Protobuf::FieldDescriptor->new(
      name => 'optional_nested_message', index => 0, number => 1,
      type => 11, cpp_type => 10, label => 1,
      default_value => undef,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
  ],
  extensions => [
  ],
  nested_types => [],  # TODO(bradfitz): Implement.
  enum_types => [
  ],
  options => Protobuf::MessageOptions->new(
  ),
);


our $_TESTCAMELCASEFIELDNAMES = Protobuf::Descriptor->new(
  name => 'TestCamelCaseFieldNames',
  full_name => 'ProtobufTestBasic::TestCamelCaseFieldNames',
  containing_type => undef,
  fields => [
    Protobuf::FieldDescriptor->new(
      name => 'PrimitiveField', index => 0, number => 1,
      type => 5, cpp_type => 1, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'StringField', index => 1, number => 2,
      type => 9, cpp_type => 9, label => 1,
      default_value => "",
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'EnumField', index => 2, number => 3,
      type => 14, cpp_type => 8, label => 1,
      default_value => 4,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'MessageField', index => 3, number => 4,
      type => 11, cpp_type => 10, label => 1,
      default_value => undef,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'StringPieceField', index => 4, number => 5,
      type => 9, cpp_type => 9, label => 1,
      default_value => "",
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'CordField', index => 5, number => 6,
      type => 9, cpp_type => 9, label => 1,
      default_value => "",
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'RepeatedPrimitiveField', index => 6, number => 7,
      type => 5, cpp_type => 1, label => 3,
      default_value => [],
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'RepeatedStringField', index => 7, number => 8,
      type => 9, cpp_type => 9, label => 3,
      default_value => [],
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'RepeatedEnumField', index => 8, number => 9,
      type => 14, cpp_type => 8, label => 3,
      default_value => [],
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'RepeatedMessageField', index => 9, number => 10,
      type => 11, cpp_type => 10, label => 3,
      default_value => [],
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'RepeatedStringPieceField', index => 10, number => 11,
      type => 9, cpp_type => 9, label => 3,
      default_value => [],
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'RepeatedCordField', index => 11, number => 12,
      type => 9, cpp_type => 9, label => 3,
      default_value => [],
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
  ],
  extensions => [
  ],
  nested_types => [],  # TODO(bradfitz): Implement.
  enum_types => [
  ],
  options => Protobuf::MessageOptions->new(
  ),
);


our $_TESTFIELDORDERINGS = Protobuf::Descriptor->new(
  name => 'TestFieldOrderings',
  full_name => 'ProtobufTestBasic::TestFieldOrderings',
  containing_type => undef,
  fields => [
    Protobuf::FieldDescriptor->new(
      name => 'my_string', index => 0, number => 11,
      type => 9, cpp_type => 9, label => 1,
      default_value => "",
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'my_int', index => 1, number => 1,
      type => 3, cpp_type => 2, label => 1,
      default_value => Protobuf::Types::BI("0"),
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'my_float', index => 2, number => 101,
      type => 2, cpp_type => 6, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
  ],
  extensions => [
  ],
  nested_types => [],  # TODO(bradfitz): Implement.
  enum_types => [
  ],
  options => Protobuf::MessageOptions->new(
  ),
);


our $_TESTEXTREMEDEFAULTVALUES = Protobuf::Descriptor->new(
  name => 'TestExtremeDefaultValues',
  full_name => 'ProtobufTestBasic::TestExtremeDefaultValues',
  containing_type => undef,
  fields => [
    Protobuf::FieldDescriptor->new(
      name => 'escaped_bytes', index => 0, number => 1,
      type => 12, cpp_type => 9, label => 1,
      default_value => "\000\001\007\010\014\n\r\t\013\\\'\"\376",
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'large_uint32', index => 1, number => 2,
      type => 13, cpp_type => 3, label => 1,
      default_value => 4294967295,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'large_uint64', index => 2, number => 3,
      type => 4, cpp_type => 4, label => 1,
      default_value => Protobuf::Types::BI("18446744073709551615"),
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'small_int32', index => 3, number => 4,
      type => 5, cpp_type => 1, label => 1,
      default_value => -2147483647,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'small_int64', index => 4, number => 5,
      type => 3, cpp_type => 2, label => 1,
      default_value => Protobuf::Types::BI("-9223372036854775807"),
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'utf8_string', index => 5, number => 6,
      type => 9, cpp_type => 9, label => 1,
      default_value => "\341\210\264",
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
  ],
  extensions => [
  ],
  nested_types => [],  # TODO(bradfitz): Implement.
  enum_types => [
  ],
  options => Protobuf::MessageOptions->new(
  ),
);


our $_FOOREQUEST = Protobuf::Descriptor->new(
  name => 'FooRequest',
  full_name => 'ProtobufTestBasic::FooRequest',
  containing_type => undef,
  fields => [
  ],
  extensions => [
  ],
  nested_types => [],  # TODO(bradfitz): Implement.
  enum_types => [
  ],
  options => Protobuf::MessageOptions->new(
  ),
);


our $_FOORESPONSE = Protobuf::Descriptor->new(
  name => 'FooResponse',
  full_name => 'ProtobufTestBasic::FooResponse',
  containing_type => undef,
  fields => [
  ],
  extensions => [
  ],
  nested_types => [],  # TODO(bradfitz): Implement.
  enum_types => [
  ],
  options => Protobuf::MessageOptions->new(
  ),
);


our $_BARREQUEST = Protobuf::Descriptor->new(
  name => 'BarRequest',
  full_name => 'ProtobufTestBasic::BarRequest',
  containing_type => undef,
  fields => [
  ],
  extensions => [
  ],
  nested_types => [],  # TODO(bradfitz): Implement.
  enum_types => [
  ],
  options => Protobuf::MessageOptions->new(
  ),
);


our $_BARRESPONSE = Protobuf::Descriptor->new(
  name => 'BarResponse',
  full_name => 'ProtobufTestBasic::BarResponse',
  containing_type => undef,
  fields => [
  ],
  extensions => [
  ],
  nested_types => [],  # TODO(bradfitz): Implement.
  enum_types => [
  ],
  options => Protobuf::MessageOptions->new(
  ),
);

## Imports:

## Fix foreign fields:
$_TESTALLTYPES->fields_by_name('optionalgroup')->set_message_type($_TESTALLTYPES_OPTIONALGROUP);
$_TESTALLTYPES->fields_by_name('optional_nested_message')->set_message_type($_TESTALLTYPES_NESTEDMESSAGE);
$_TESTALLTYPES->fields_by_name('optional_foreign_message')->set_message_type($_FOREIGNMESSAGE);
$_TESTALLTYPES->fields_by_name('optional_nested_enum')->set_enum_type($_TESTALLTYPES_NESTEDENUM);
$_TESTALLTYPES->fields_by_name('optional_foreign_enum')->set_enum_type($_FOREIGNENUM);
$_TESTALLTYPES->fields_by_name('repeatedgroup')->set_message_type($_TESTALLTYPES_REPEATEDGROUP);
$_TESTALLTYPES->fields_by_name('repeated_nested_message')->set_message_type($_TESTALLTYPES_NESTEDMESSAGE);
$_TESTALLTYPES->fields_by_name('repeated_foreign_message')->set_message_type($_FOREIGNMESSAGE);
$_TESTALLTYPES->fields_by_name('repeated_nested_enum')->set_enum_type($_TESTALLTYPES_NESTEDENUM);
$_TESTALLTYPES->fields_by_name('repeated_foreign_enum')->set_enum_type($_FOREIGNENUM);
$_TESTALLTYPES->fields_by_name('default_nested_enum')->set_enum_type($_TESTALLTYPES_NESTEDENUM);
$_TESTALLTYPES->fields_by_name('default_foreign_enum')->set_enum_type($_FOREIGNENUM);
$_TESTREQUIREDFOREIGN->fields_by_name('optional_message')->set_message_type($_TESTREQUIRED);
$_TESTREQUIREDFOREIGN->fields_by_name('repeated_message')->set_message_type($_TESTREQUIRED);
$_TESTFOREIGNNESTED->fields_by_name('foreign_nested')->set_message_type($_TESTALLTYPES_NESTEDMESSAGE);
$_TESTRECURSIVEMESSAGE->fields_by_name('a')->set_message_type($_TESTRECURSIVEMESSAGE);
$_TESTMUTUALRECURSIONA->fields_by_name('bb')->set_message_type($_TESTMUTUALRECURSIONB);
$_TESTMUTUALRECURSIONB->fields_by_name('a')->set_message_type($_TESTMUTUALRECURSIONA);
$_TESTDUPFIELDNUMBER->fields_by_name('foo')->set_message_type($_TESTDUPFIELDNUMBER_FOO);
$_TESTDUPFIELDNUMBER->fields_by_name('bar')->set_message_type($_TESTDUPFIELDNUMBER_BAR);
$_TESTNESTEDMESSAGEHASBITS_NESTEDMESSAGE->fields_by_name('nestedmessage_repeated_foreignmessage')->set_message_type($_FOREIGNMESSAGE);
$_TESTNESTEDMESSAGEHASBITS->fields_by_name('optional_nested_message')->set_message_type($_TESTNESTEDMESSAGEHASBITS_NESTEDMESSAGE);
$_TESTCAMELCASEFIELDNAMES->fields_by_name('EnumField')->set_enum_type($_FOREIGNENUM);
$_TESTCAMELCASEFIELDNAMES->fields_by_name('MessageField')->set_message_type($_FOREIGNMESSAGE);
$_TESTCAMELCASEFIELDNAMES->fields_by_name('RepeatedEnumField')->set_enum_type($_FOREIGNENUM);
$_TESTCAMELCASEFIELDNAMES->fields_by_name('RepeatedMessageField')->set_message_type($_FOREIGNMESSAGE);

## Messages:
Protobuf::Message->GenerateClass(__PACKAGE__ . '::TestAllTypes', $_TESTALLTYPES);
Protobuf::Message->GenerateClass(__PACKAGE__ . '::TestAllTypes::NestedMessage', $_TESTALLTYPES_NESTEDMESSAGE);
Protobuf::Message->GenerateClass(__PACKAGE__ . '::TestAllTypes::OptionalGroup', $_TESTALLTYPES_OPTIONALGROUP);
Protobuf::Message->GenerateClass(__PACKAGE__ . '::TestAllTypes::RepeatedGroup', $_TESTALLTYPES_REPEATEDGROUP);

Protobuf::Message->GenerateClass(__PACKAGE__ . '::ForeignMessage', $_FOREIGNMESSAGE);

Protobuf::Message->GenerateClass(__PACKAGE__ . '::TestRequired', $_TESTREQUIRED);

Protobuf::Message->GenerateClass(__PACKAGE__ . '::TestRequiredForeign', $_TESTREQUIREDFOREIGN);

Protobuf::Message->GenerateClass(__PACKAGE__ . '::TestForeignNested', $_TESTFOREIGNNESTED);

Protobuf::Message->GenerateClass(__PACKAGE__ . '::TestEmptyMessage', $_TESTEMPTYMESSAGE);

Protobuf::Message->GenerateClass(__PACKAGE__ . '::TestReallyLargeTagNumber', $_TESTREALLYLARGETAGNUMBER);

Protobuf::Message->GenerateClass(__PACKAGE__ . '::TestRecursiveMessage', $_TESTRECURSIVEMESSAGE);

Protobuf::Message->GenerateClass(__PACKAGE__ . '::TestMutualRecursionA', $_TESTMUTUALRECURSIONA);

Protobuf::Message->GenerateClass(__PACKAGE__ . '::TestMutualRecursionB', $_TESTMUTUALRECURSIONB);

Protobuf::Message->GenerateClass(__PACKAGE__ . '::TestDupFieldNumber', $_TESTDUPFIELDNUMBER);
Protobuf::Message->GenerateClass(__PACKAGE__ . '::TestDupFieldNumber::Foo', $_TESTDUPFIELDNUMBER_FOO);
Protobuf::Message->GenerateClass(__PACKAGE__ . '::TestDupFieldNumber::Bar', $_TESTDUPFIELDNUMBER_BAR);

Protobuf::Message->GenerateClass(__PACKAGE__ . '::TestNestedMessageHasBits', $_TESTNESTEDMESSAGEHASBITS);
Protobuf::Message->GenerateClass(__PACKAGE__ . '::TestNestedMessageHasBits::NestedMessage', $_TESTNESTEDMESSAGEHASBITS_NESTEDMESSAGE);

Protobuf::Message->GenerateClass(__PACKAGE__ . '::TestCamelCaseFieldNames', $_TESTCAMELCASEFIELDNAMES);

Protobuf::Message->GenerateClass(__PACKAGE__ . '::TestFieldOrderings', $_TESTFIELDORDERINGS);

Protobuf::Message->GenerateClass(__PACKAGE__ . '::TestExtremeDefaultValues', $_TESTEXTREMEDEFAULTVALUES);

Protobuf::Message->GenerateClass(__PACKAGE__ . '::FooRequest', $_FOOREQUEST);

Protobuf::Message->GenerateClass(__PACKAGE__ . '::FooResponse', $_FOORESPONSE);

Protobuf::Message->GenerateClass(__PACKAGE__ . '::BarRequest', $_BARREQUEST);

Protobuf::Message->GenerateClass(__PACKAGE__ . '::BarResponse', $_BARRESPONSE);

## Fix foreign fields in extensions:
## Services:

1;
