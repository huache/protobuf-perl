## Boilerplate:
# Auto-generated code from the protocol buffer compiler.  DO NOT EDIT!

use strict;
use warnings;
use 5.6.1;
use Protobuf;

package AppEngine::Service::MemcacheProto;

package AppEngine::Service;

use constant TRUE => 1;
use constant FALSE => 0;
## Top-level enums:

## Top-level extensions:

## All nested enums:
our $_MEMCACHESERVICEERROR_ERRORCODE = Protobuf::EnumDescriptor->new(
  name => 'ErrorCode',
  full_name => 'appengine_api.MemcacheServiceError.ErrorCode',
  values => [
    Protobuf::EnumValueDescriptor->new(name => 'OK', index => 0, number => 0, type => undef),
    Protobuf::EnumValueDescriptor->new(name => 'UNSPECIFIED_ERROR', index => 1, number => 1, type => undef),
]);
$_MEMCACHESERVICEERROR_ERRORCODE->values->[0]->set_type($_MEMCACHESERVICEERROR_ERRORCODE);
$_MEMCACHESERVICEERROR_ERRORCODE->values->[1]->set_type($_MEMCACHESERVICEERROR_ERRORCODE);

our $_MEMCACHESETREQUEST_SETPOLICY = Protobuf::EnumDescriptor->new(
  name => 'SetPolicy',
  full_name => 'appengine_api.MemcacheSetRequest.SetPolicy',
  values => [
    Protobuf::EnumValueDescriptor->new(name => 'SET', index => 0, number => 1, type => undef),
    Protobuf::EnumValueDescriptor->new(name => 'ADD', index => 1, number => 2, type => undef),
    Protobuf::EnumValueDescriptor->new(name => 'REPLACE', index => 2, number => 3, type => undef),
]);
$_MEMCACHESETREQUEST_SETPOLICY->values->[0]->set_type($_MEMCACHESETREQUEST_SETPOLICY);
$_MEMCACHESETREQUEST_SETPOLICY->values->[1]->set_type($_MEMCACHESETREQUEST_SETPOLICY);
$_MEMCACHESETREQUEST_SETPOLICY->values->[2]->set_type($_MEMCACHESETREQUEST_SETPOLICY);

our $_MEMCACHESETRESPONSE_SETSTATUSCODE = Protobuf::EnumDescriptor->new(
  name => 'SetStatusCode',
  full_name => 'appengine_api.MemcacheSetResponse.SetStatusCode',
  values => [
    Protobuf::EnumValueDescriptor->new(name => 'STORED', index => 0, number => 1, type => undef),
    Protobuf::EnumValueDescriptor->new(name => 'NOT_STORED', index => 1, number => 2, type => undef),
    Protobuf::EnumValueDescriptor->new(name => 'ERROR', index => 2, number => 3, type => undef),
]);
$_MEMCACHESETRESPONSE_SETSTATUSCODE->values->[0]->set_type($_MEMCACHESETRESPONSE_SETSTATUSCODE);
$_MEMCACHESETRESPONSE_SETSTATUSCODE->values->[1]->set_type($_MEMCACHESETRESPONSE_SETSTATUSCODE);
$_MEMCACHESETRESPONSE_SETSTATUSCODE->values->[2]->set_type($_MEMCACHESETRESPONSE_SETSTATUSCODE);

our $_MEMCACHEDELETERESPONSE_DELETESTATUSCODE = Protobuf::EnumDescriptor->new(
  name => 'DeleteStatusCode',
  full_name => 'appengine_api.MemcacheDeleteResponse.DeleteStatusCode',
  values => [
    Protobuf::EnumValueDescriptor->new(name => 'DELETED', index => 0, number => 1, type => undef),
    Protobuf::EnumValueDescriptor->new(name => 'NOT_FOUND', index => 1, number => 2, type => undef),
]);
$_MEMCACHEDELETERESPONSE_DELETESTATUSCODE->values->[0]->set_type($_MEMCACHEDELETERESPONSE_DELETESTATUSCODE);
$_MEMCACHEDELETERESPONSE_DELETESTATUSCODE->values->[1]->set_type($_MEMCACHEDELETERESPONSE_DELETESTATUSCODE);

our $_MEMCACHEINCREMENTREQUEST_DIRECTION = Protobuf::EnumDescriptor->new(
  name => 'Direction',
  full_name => 'appengine_api.MemcacheIncrementRequest.Direction',
  values => [
    Protobuf::EnumValueDescriptor->new(name => 'INCREMENT', index => 0, number => 1, type => undef),
    Protobuf::EnumValueDescriptor->new(name => 'DECREMENT', index => 1, number => 2, type => undef),
]);
$_MEMCACHEINCREMENTREQUEST_DIRECTION->values->[0]->set_type($_MEMCACHEINCREMENTREQUEST_DIRECTION);
$_MEMCACHEINCREMENTREQUEST_DIRECTION->values->[1]->set_type($_MEMCACHEINCREMENTREQUEST_DIRECTION);

## Message descriptors:

our $_MEMCACHESERVICEERROR = Protobuf::Descriptor->new(
  name => 'MemcacheServiceError',
  full_name => 'appengine_api.MemcacheServiceError',
  containing_type => undef,
  fields => [
  ],
  extensions => [
  ],
  nested_types => [],  # TODO(bradfitz): Implement.
  enum_types => [
    $_MEMCACHESERVICEERROR_ERRORCODE,
  ],
  options => Protobuf::MessageOptions->new(
  ),
);


our $_MEMCACHEGETREQUEST = Protobuf::Descriptor->new(
  name => 'MemcacheGetRequest',
  full_name => 'appengine_api.MemcacheGetRequest',
  containing_type => undef,
  fields => [
    Protobuf::FieldDescriptor->new(
      name => 'key', index => 0, number => 1,
      type => 12, cpp_type => 9, label => 3,
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


our $_MEMCACHEGETRESPONSE_ITEM = Protobuf::Descriptor->new(
  name => 'Item',
  full_name => 'appengine_api.MemcacheGetResponse.Item',
  containing_type => undef,
  fields => [
    Protobuf::FieldDescriptor->new(
      name => 'key', index => 0, number => 2,
      type => 12, cpp_type => 9, label => 2,
      default_value => "",
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'value', index => 1, number => 3,
      type => 12, cpp_type => 9, label => 2,
      default_value => "",
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'flags', index => 2, number => 4,
      type => 7, cpp_type => 3, label => 1,
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

our $_MEMCACHEGETRESPONSE = Protobuf::Descriptor->new(
  name => 'MemcacheGetResponse',
  full_name => 'appengine_api.MemcacheGetResponse',
  containing_type => undef,
  fields => [
    Protobuf::FieldDescriptor->new(
      name => 'item', index => 0, number => 1,
      type => 10, cpp_type => 10, label => 3,
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


our $_MEMCACHESETREQUEST_ITEM = Protobuf::Descriptor->new(
  name => 'Item',
  full_name => 'appengine_api.MemcacheSetRequest.Item',
  containing_type => undef,
  fields => [
    Protobuf::FieldDescriptor->new(
      name => 'key', index => 0, number => 2,
      type => 12, cpp_type => 9, label => 2,
      default_value => "",
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'value', index => 1, number => 3,
      type => 12, cpp_type => 9, label => 2,
      default_value => "",
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'flags', index => 2, number => 4,
      type => 7, cpp_type => 3, label => 1,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'set_policy', index => 3, number => 5,
      type => 14, cpp_type => 8, label => 1,
      default_value => 1,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'expiration_time', index => 4, number => 6,
      type => 7, cpp_type => 3, label => 1,
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

our $_MEMCACHESETREQUEST = Protobuf::Descriptor->new(
  name => 'MemcacheSetRequest',
  full_name => 'appengine_api.MemcacheSetRequest',
  containing_type => undef,
  fields => [
    Protobuf::FieldDescriptor->new(
      name => 'item', index => 0, number => 1,
      type => 10, cpp_type => 10, label => 3,
      default_value => [],
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
  ],
  extensions => [
  ],
  nested_types => [],  # TODO(bradfitz): Implement.
  enum_types => [
    $_MEMCACHESETREQUEST_SETPOLICY,
  ],
  options => Protobuf::MessageOptions->new(
  ),
);


our $_MEMCACHESETRESPONSE = Protobuf::Descriptor->new(
  name => 'MemcacheSetResponse',
  full_name => 'appengine_api.MemcacheSetResponse',
  containing_type => undef,
  fields => [
    Protobuf::FieldDescriptor->new(
      name => 'set_status', index => 0, number => 1,
      type => 14, cpp_type => 8, label => 3,
      default_value => [],
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
  ],
  extensions => [
  ],
  nested_types => [],  # TODO(bradfitz): Implement.
  enum_types => [
    $_MEMCACHESETRESPONSE_SETSTATUSCODE,
  ],
  options => Protobuf::MessageOptions->new(
  ),
);


our $_MEMCACHEDELETEREQUEST_ITEM = Protobuf::Descriptor->new(
  name => 'Item',
  full_name => 'appengine_api.MemcacheDeleteRequest.Item',
  containing_type => undef,
  fields => [
    Protobuf::FieldDescriptor->new(
      name => 'key', index => 0, number => 2,
      type => 12, cpp_type => 9, label => 2,
      default_value => "",
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'delete_time', index => 1, number => 3,
      type => 7, cpp_type => 3, label => 1,
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

our $_MEMCACHEDELETEREQUEST = Protobuf::Descriptor->new(
  name => 'MemcacheDeleteRequest',
  full_name => 'appengine_api.MemcacheDeleteRequest',
  containing_type => undef,
  fields => [
    Protobuf::FieldDescriptor->new(
      name => 'item', index => 0, number => 1,
      type => 10, cpp_type => 10, label => 3,
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


our $_MEMCACHEDELETERESPONSE = Protobuf::Descriptor->new(
  name => 'MemcacheDeleteResponse',
  full_name => 'appengine_api.MemcacheDeleteResponse',
  containing_type => undef,
  fields => [
    Protobuf::FieldDescriptor->new(
      name => 'delete_status', index => 0, number => 1,
      type => 14, cpp_type => 8, label => 3,
      default_value => [],
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
  ],
  extensions => [
  ],
  nested_types => [],  # TODO(bradfitz): Implement.
  enum_types => [
    $_MEMCACHEDELETERESPONSE_DELETESTATUSCODE,
  ],
  options => Protobuf::MessageOptions->new(
  ),
);


our $_MEMCACHEINCREMENTREQUEST = Protobuf::Descriptor->new(
  name => 'MemcacheIncrementRequest',
  full_name => 'appengine_api.MemcacheIncrementRequest',
  containing_type => undef,
  fields => [
    Protobuf::FieldDescriptor->new(
      name => 'key', index => 0, number => 1,
      type => 12, cpp_type => 9, label => 2,
      default_value => "",
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'delta', index => 1, number => 2,
      type => 4, cpp_type => 4, label => 1,
      default_value => 1,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'direction', index => 2, number => 3,
      type => 14, cpp_type => 8, label => 1,
      default_value => 1,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
  ],
  extensions => [
  ],
  nested_types => [],  # TODO(bradfitz): Implement.
  enum_types => [
    $_MEMCACHEINCREMENTREQUEST_DIRECTION,
  ],
  options => Protobuf::MessageOptions->new(
  ),
);


our $_MEMCACHEINCREMENTRESPONSE = Protobuf::Descriptor->new(
  name => 'MemcacheIncrementResponse',
  full_name => 'appengine_api.MemcacheIncrementResponse',
  containing_type => undef,
  fields => [
    Protobuf::FieldDescriptor->new(
      name => 'new_value', index => 0, number => 1,
      type => 4, cpp_type => 4, label => 1,
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


our $_MEMCACHEFLUSHREQUEST = Protobuf::Descriptor->new(
  name => 'MemcacheFlushRequest',
  full_name => 'appengine_api.MemcacheFlushRequest',
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


our $_MEMCACHEFLUSHRESPONSE = Protobuf::Descriptor->new(
  name => 'MemcacheFlushResponse',
  full_name => 'appengine_api.MemcacheFlushResponse',
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


our $_MEMCACHESTATSREQUEST = Protobuf::Descriptor->new(
  name => 'MemcacheStatsRequest',
  full_name => 'appengine_api.MemcacheStatsRequest',
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


our $_MERGEDNAMESPACESTATS = Protobuf::Descriptor->new(
  name => 'MergedNamespaceStats',
  full_name => 'appengine_api.MergedNamespaceStats',
  containing_type => undef,
  fields => [
    Protobuf::FieldDescriptor->new(
      name => 'hits', index => 0, number => 1,
      type => 4, cpp_type => 4, label => 2,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'misses', index => 1, number => 2,
      type => 4, cpp_type => 4, label => 2,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'byte_hits', index => 2, number => 3,
      type => 4, cpp_type => 4, label => 2,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'items', index => 3, number => 4,
      type => 4, cpp_type => 4, label => 2,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'bytes', index => 4, number => 5,
      type => 4, cpp_type => 4, label => 2,
      default_value => 0,
      message_type => undef, enum_type => undef, containing_type => undef,
      is_extension => FALSE, extension_scope => undef),
    Protobuf::FieldDescriptor->new(
      name => 'oldest_item_age', index => 5, number => 6,
      type => 7, cpp_type => 3, label => 2,
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


our $_MEMCACHESTATSRESPONSE = Protobuf::Descriptor->new(
  name => 'MemcacheStatsResponse',
  full_name => 'appengine_api.MemcacheStatsResponse',
  containing_type => undef,
  fields => [
    Protobuf::FieldDescriptor->new(
      name => 'stats', index => 0, number => 1,
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

## Imports:

## Fix foreign fields:
$_MEMCACHEGETRESPONSE->fields_by_name('item')->set_message_type($_MEMCACHEGETRESPONSE_ITEM);
$_MEMCACHESETREQUEST_ITEM->fields_by_name('set_policy')->set_enum_type($_MEMCACHESETREQUEST_SETPOLICY);
$_MEMCACHESETREQUEST->fields_by_name('item')->set_message_type($_MEMCACHESETREQUEST_ITEM);
$_MEMCACHESETRESPONSE->fields_by_name('set_status')->set_enum_type($_MEMCACHESETRESPONSE_SETSTATUSCODE);
$_MEMCACHEDELETEREQUEST->fields_by_name('item')->set_message_type($_MEMCACHEDELETEREQUEST_ITEM);
$_MEMCACHEDELETERESPONSE->fields_by_name('delete_status')->set_enum_type($_MEMCACHEDELETERESPONSE_DELETESTATUSCODE);
$_MEMCACHEINCREMENTREQUEST->fields_by_name('direction')->set_enum_type($_MEMCACHEINCREMENTREQUEST_DIRECTION);
$_MEMCACHESTATSRESPONSE->fields_by_name('stats')->set_message_type($_MERGEDNAMESPACESTATS);

## Messages:
Protobuf::Message->GenerateClass(__PACKAGE__ . '::MemcacheServiceError', $_MEMCACHESERVICEERROR);

Protobuf::Message->GenerateClass(__PACKAGE__ . '::MemcacheGetRequest', $_MEMCACHEGETREQUEST);

Protobuf::Message->GenerateClass(__PACKAGE__ . '::MemcacheGetResponse', $_MEMCACHEGETRESPONSE);
Protobuf::Message->GenerateClass(__PACKAGE__ . '::MemcacheGetResponse::Item', $_MEMCACHEGETRESPONSE_ITEM);

Protobuf::Message->GenerateClass(__PACKAGE__ . '::MemcacheSetRequest', $_MEMCACHESETREQUEST);
Protobuf::Message->GenerateClass(__PACKAGE__ . '::MemcacheSetRequest::Item', $_MEMCACHESETREQUEST_ITEM);

Protobuf::Message->GenerateClass(__PACKAGE__ . '::MemcacheSetResponse', $_MEMCACHESETRESPONSE);

Protobuf::Message->GenerateClass(__PACKAGE__ . '::MemcacheDeleteRequest', $_MEMCACHEDELETEREQUEST);
Protobuf::Message->GenerateClass(__PACKAGE__ . '::MemcacheDeleteRequest::Item', $_MEMCACHEDELETEREQUEST_ITEM);

Protobuf::Message->GenerateClass(__PACKAGE__ . '::MemcacheDeleteResponse', $_MEMCACHEDELETERESPONSE);

Protobuf::Message->GenerateClass(__PACKAGE__ . '::MemcacheIncrementRequest', $_MEMCACHEINCREMENTREQUEST);

Protobuf::Message->GenerateClass(__PACKAGE__ . '::MemcacheIncrementResponse', $_MEMCACHEINCREMENTRESPONSE);

Protobuf::Message->GenerateClass(__PACKAGE__ . '::MemcacheFlushRequest', $_MEMCACHEFLUSHREQUEST);

Protobuf::Message->GenerateClass(__PACKAGE__ . '::MemcacheFlushResponse', $_MEMCACHEFLUSHRESPONSE);

Protobuf::Message->GenerateClass(__PACKAGE__ . '::MemcacheStatsRequest', $_MEMCACHESTATSREQUEST);

Protobuf::Message->GenerateClass(__PACKAGE__ . '::MergedNamespaceStats', $_MERGEDNAMESPACESTATS);

Protobuf::Message->GenerateClass(__PACKAGE__ . '::MemcacheStatsResponse', $_MEMCACHESTATSRESPONSE);

## Fix foreign fields in extensions:
## Services:
