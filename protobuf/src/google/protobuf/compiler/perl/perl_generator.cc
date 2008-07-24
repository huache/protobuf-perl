// Copyright 2008 Google Inc. All Rights Reserved.
//
// This module outputs pure-Perl protocol message classes that will
// largely be constructed at runtime.
//
// Note that, like the pure-Python implementation of protocol buffers,
// the runtime performance of protocol message classes created in this
// way is expected to be lousy.  XS implementations of the slow parts
// can be done in the future.

#include <utility>
#include <map>
#include <string>
#include <vector>

#include <google/protobuf/compiler/perl/perl_generator.h>
#include <google/protobuf/descriptor.pb.h>

#include <google/protobuf/stubs/common.h>
#include <google/protobuf/io/printer.h>
#include <google/protobuf/descriptor.h>
#include <google/protobuf/io/zero_copy_stream.h>
#include <google/protobuf/stubs/strutil.h>
#include <google/protobuf/stubs/substitute.h>

namespace google {
namespace protobuf {
namespace compiler {
namespace perl {

namespace {

// Returns a copy of |filename| with any trailing ".protodevel" or ".proto
// suffix stripped.
// TODO(xxx): Unify with copy in compiler/cpp/internal/helpers.cc.
string StripProto(const string& filename) {
  const char* suffix = HasSuffixString(filename, ".protodevel")
      ? ".protodevel" : ".proto";
  return StripSuffixString(filename, suffix);
}


// Returns the Perl package name expected for a given .proto filename.
string PackageName(const string& filename) {
  string package = StripProto(filename);
  StripString(&package, "-", '_');
  GlobalReplaceSubstring("_", "::", &package);
  GlobalReplaceSubstring("/", "::", &package);
  return "ProtoBuf::" + package;
}


// Returns the name of all containing types for descriptor,
// in order from outermost to innermost, followed by descriptor's
// own name.  Each name is separated by |separator|.
template <typename DescriptorT>
string NamePrefixedWithNestedTypes(const DescriptorT& descriptor,
                                   const string& separator) {
  string name = descriptor.name();
  for (const Descriptor* current = descriptor.containing_type();
       current != NULL; current = current->containing_type()) {
    name = current->name() + separator + name;
  }
  return name;
}


// Name of the class attribute where we store the Perl
// descriptor.Descriptor instance for the generated class.
// Must stay consistent with the _DESCRIPTOR_KEY constant
// in proto2/public/reflection.py.
const char kDescriptorKey[] = "DESCRIPTOR";


// Prints the common boilerplate needed at the top of every .py
// file output by this generator.
void PrintTopBoilerplate(io::Printer* printer) {
  printer->Print(
      "# Auto-generated code from the protocol buffer compiler.  DO NOT EDIT!\n"
      "\n"
      "use strict;\n"
      "use warnings;\n"
      "use 5.6.1;\n"
      "use Google::Net::Proto2::Descriptor;\n"
      "use Google::Net::Proto2::EnumDescriptor;\n"
      "use Google::Net::Proto2::EnumValueDescriptor;\n"
      "use Google::Net::Proto2::FieldDescriptor;\n"
      "use Google::Net::Proto2::Message;\n"
      "\n");
}

// Returns a Perl expression that instantiates a Perl EnumValueDescriptor
// object for the given C++ descriptor.
string EnumValueDescriptorExpression(
    const EnumValueDescriptor& descriptor) {
  // TODO(bradfitz): Fix up EnumValueDescriptor "type" fields.
  // More circular references.  ::sigh::
  return strings::Substitute("EnumValueDescriptor->new("
                             "name => '$0', "
                             "index => $1, "
                             "number => $2, "
                             "type => undef)",
                             descriptor.name(),
                             descriptor.index(),
                             descriptor.number());
}


// Returns a Perl literal giving the default value for a field.
// If the field specifies no explicit default value, we'll return
// the default default value for the field type (zero for numbers,
// empty string for strings, empty list for repeated fields, and
// None for non-repeated, composite fields).
string StringifyDefaultValue(const FieldDescriptor& field) {
  if (field.label() == FieldDescriptor::LABEL_REPEATED) {
    return "[]";
  }

  switch (field.cpp_type()) {
    case FieldDescriptor::CPPTYPE_INT32:
      return SimpleItoa(field.default_value_int32());
    case FieldDescriptor::CPPTYPE_UINT32:
      return SimpleItoa(field.default_value_uint32());
    case FieldDescriptor::CPPTYPE_INT64:
      return SimpleItoa(field.default_value_int64());
    case FieldDescriptor::CPPTYPE_UINT64:
      return SimpleItoa(field.default_value_uint64());
    case FieldDescriptor::CPPTYPE_DOUBLE:
      return SimpleDtoa(field.default_value_double());
    case FieldDescriptor::CPPTYPE_FLOAT:
      return SimpleFtoa(field.default_value_float());
    case FieldDescriptor::CPPTYPE_BOOL:
      return field.default_value_bool() ? "1" : "0";
    case FieldDescriptor::CPPTYPE_ENUM:
      return SimpleItoa(field.default_value_enum()->number());
    case FieldDescriptor::CPPTYPE_STRING:
      return "\"" + CEscape(field.default_value_string()) + "\"";
    case FieldDescriptor::CPPTYPE_MESSAGE:
      return "undef";
  }
  // (We could add a default case above but then we wouldn't get the nice
  // compiler warning when a new type is added.)
  GOOGLE_LOG(FATAL) << "Not reached.";
  return "";
}


// Prints an expression for a Perl FieldDescriptor for |field|.
void PrintFieldDescriptor(const FieldDescriptor& field, bool is_extension,
                          io::Printer* printer) {
  map<string, string> m;
  m["name"] = field.name();
  m["index"] = SimpleItoa(field.index());
  m["number"] = SimpleItoa(field.number());
  m["type"] = SimpleItoa(field.type());
  m["cpp_type"] = SimpleItoa(field.cpp_type());
  m["label"] = SimpleItoa(field.label());
  m["default_value"] = StringifyDefaultValue(field);
  m["is_extension"] = is_extension ? "True" : "False";
  // We always set message_type and enum_type to None at this point, and then
  // these fields in correctly after all referenced descriptors have been
  // defined and/or imported (see FixForeignFieldsInDescriptors()).
  const char field_descriptor_decl[] =
      "FieldDescriptor->new(\n"
      "  name => '`name`', index => `index`, number => `number`,\n"
      "  type => `type`, cpp_type => `cpp_type`, label => `label`,\n"
      "  default_value => `default_value`,\n"
      "  message_type => undef, enum_type => undef, containing_type => undef,\n"
      "  is_extension => `is_extension`, extension_scope => undef)";
  printer->Print(m, field_descriptor_decl);
}


// Helper for Print{Fields,Extensions}InDescriptor().
void PrintFieldDescriptorsInDescriptor(
    const Descriptor& message_descriptor,
    bool is_extension,
    const string& list_variable_name,
    int (Descriptor::*CountFn)() const,
    const FieldDescriptor* (Descriptor::*GetterFn)(int) const,
    io::Printer* printer) {
  printer->Print("`list` => [\n", "list", list_variable_name);
  printer->Indent();
  for (int i = 0; i < (message_descriptor.*CountFn)(); ++i) {
    PrintFieldDescriptor(*(message_descriptor.*GetterFn)(i),
                         is_extension, printer);
    printer->Print(",\n");
  }
  printer->Outdent();
  printer->Print("],\n");
}


// Prints a statement assigning "fields" to a list of Perl FieldDescriptors,
// one for each field present in message_descriptor.
void PrintFieldsInDescriptor(const Descriptor& message_descriptor,
                             io::Printer* printer) {
  const bool is_extension = false;
  PrintFieldDescriptorsInDescriptor(
      message_descriptor, is_extension, "fields",
      &Descriptor::field_count, &Descriptor::field,
      printer);
}

// Prints a statement assigning "extensions" to a list of Perl
// FieldDescriptors, one for each extension present in message_descriptor.
void PrintExtensionsInDescriptor(
    const Descriptor& message_descriptor, io::Printer* printer) {
  const bool is_extension = true;
  PrintFieldDescriptorsInDescriptor(
      message_descriptor, is_extension, "extensions",
      &Descriptor::extension_count, &Descriptor::extension,
      printer);
}

// Prints the list of options set for the message.
void PrintOptionsInDescriptor(
    const Descriptor& message_descriptor, io::Printer* printer) {
  vector<const FieldDescriptor*> fields;
  const Message::Reflection *reflection =
      message_descriptor.options().GetReflection();
  reflection->ListFields(&fields);

  printer->Print("options => MessageOptions->new(\n");
  vector<const FieldDescriptor*>::iterator iter;
  for (iter = fields.begin(); iter != fields.end(); ++iter) {
    if ((*iter)->label() == FieldDescriptor::LABEL_REPEATED) {
      GOOGLE_LOG(FATAL) << "Can't handle repeated message option \""
                        << (*iter)->name() << "\"";
    }
    printer->Print("  `field_name` => ", "field_name", (*iter)->name());
    string value;
    switch ((*iter)->cpp_type()) {
      case FieldDescriptor::CPPTYPE_BOOL:
        value = reflection->GetBool(*iter) ? "1" : "0";
        break;
      case FieldDescriptor::CPPTYPE_INT32:
        value = SimpleItoa(reflection->GetInt32(*iter));
        break;
      case FieldDescriptor::CPPTYPE_INT64:
        value = SimpleItoa(reflection->GetInt64(*iter));
        break;
      case FieldDescriptor::CPPTYPE_STRING:
        value = "'" + CEscape(reflection->GetString(*iter)) + "'";
        break;
      default:
        GOOGLE_LOG(FATAL) << "Can't handle type of message option \""
                          << (*iter)->name()
                          << "\".";
        break;
    }
    printer->Print("`value`,\n", "value", value);
  }
  printer->Print("),\n");
}


// TODO(bradfitz): implement service output.
void PrintServices() {
}

}  // namespace


Generator::Generator() : file_(NULL) {
}

Generator::~Generator() {
}

bool Generator::Generate(const FileDescriptor* file,
                         const string& parameter,
                         OutputDirectory* output_directory,
                         string* error) const {
  // Completely serialize all Generate() calls on this instance.  The
  // thread-safety constraints of the CodeGenerator interface aren't clear so
  // just be as conservative as possible.  It's easier to relax this later if
  // we need to, but I doubt it will be an issue.
  MutexLock lock(&mutex_);
  file_ = file;
  string package_name = PackageName(file->name());
  string filename = package_name;

  GlobalReplaceSubstring("::", "/", &filename);
  filename += ".pm";

  scoped_ptr<io::ZeroCopyOutputStream> output(output_directory->Open(filename));
  GOOGLE_CHECK(output.get());
  io::Printer printer(output.get(), '`');
  printer_ = &printer;

  printer_->Print("## Boilerplate:\n");
  PrintTopBoilerplate(printer_);
  printer_->Print("package `package_name`;\n\n",
                  "package_name", package_name);
  printer_->Print(
      "use constant Message => \"Google::Net::Proto2::Message\";\n"
      "use constant Descriptor => \"Google::Net::Proto2::Descriptor\";\n"
      "use constant EnumDescriptor => "
      "\"Google::Net::Proto2::EnumDescriptor\";\n"
      "use constant EnumValueDescriptor => "
      "\"Google::Net::Proto2::EnumValueDescriptor\";\n"
      "use constant FieldDescriptor => "
      "\"Google::Net::Proto2::FieldDescriptor\";\n"
      "\n");

  printer_->Print("## Top-level enums:\n");
  PrintTopLevelEnums();
  printer_->Print("## Top-level extensions:\n");
  PrintTopLevelExtensions();
  printer_->Print("## All nested enums:\n");
  PrintAllNestedEnumsInFile();
  printer_->Print("## Message descriptors:\n");
  PrintMessageDescriptors();
  // We have to print the imports after the descriptors, so that mutually
  // recursive protos in separate files can successfully reference each other.
  // TODO(bradfitz): is this true? i tried to reproduce it but was denied.
  printer_->Print("## Imports:\n");
  PrintImports();
  printer_->Print("## Fix foreign fields:\n");
  FixForeignFieldsInDescriptors();
  printer_->Print("## Messages:\n");
  PrintMessages();
  // We have to fix up the extensions after the message classes themselves,
  // since they need to call static RegisterExtension() methods on these
  // classes.
  printer_->Print("## Fix foreign fields in extensions:\n");
  FixForeignFieldsInExtensions();
  printer_->Print("## Services:\n");
  PrintServices();
  return !printer.failed();
}

// Prints Perl imports for all modules imported by |file|.
void Generator::PrintImports() const {
  for (int i = 0; i < file_->dependency_count(); ++i) {
    string module_name = PackageName(file_->dependency(i)->name());
    printer_->Print("eval \"use `module`;\";\n", "module",
                    module_name);
  }
  printer_->Print("\n");
}

// Prints descriptors and module-level constants for all top-level
// enums defined in |file|.
void Generator::PrintTopLevelEnums() const {
  vector<pair<string, int> > top_level_enum_values;
  for (int i = 0; i < file_->enum_type_count(); ++i) {
    const EnumDescriptor& enum_descriptor = *file_->enum_type(i);
    PrintEnum(enum_descriptor);
    printer_->Print("\n");

    for (int j = 0; j < enum_descriptor.value_count(); ++j) {
      const EnumValueDescriptor& value_descriptor = *enum_descriptor.value(j);
      top_level_enum_values.push_back(
          make_pair(value_descriptor.name(), value_descriptor.number()));
    }
  }

  for (int i = 0; i < top_level_enum_values.size(); ++i) {
    printer_->Print("`name` = `value`;\n",
                    "name", top_level_enum_values[i].first,
                    "value", SimpleItoa(top_level_enum_values[i].second));
  }
  printer_->Print("\n");
}

// Prints all enums contained in all message types in |file|.
void Generator::PrintAllNestedEnumsInFile() const {
  for (int i = 0; i < file_->message_type_count(); ++i) {
    PrintNestedEnums(*file_->message_type(i));
  }
}

// Prints a Perl statement assigning the appropriate module-level
// enum name to a Perl EnumDescriptor object equivalent to
// enum_descriptor.
void Generator::PrintEnum(const EnumDescriptor& enum_descriptor) const {
  map<string, string> m;
  m["descriptor_name"] = ModuleLevelDescriptorName(enum_descriptor);
  m["name"] = enum_descriptor.name();
  m["full_name"] = enum_descriptor.full_name();
  m["filename"] = enum_descriptor.name();
  const char enum_descriptor_template[] =
      "our $`descriptor_name` = EnumDescriptor->new(\n"
      "  name => '`name`',\n"
      "  full_name => '`full_name`',\n"
      "  filename => '`filename`',\n"
      "  values => [\n";
  printer_->Print(m, enum_descriptor_template);
  printer_->Indent();
  printer_->Indent();
  for (int i = 0; i < enum_descriptor.value_count(); ++i) {
    const string e = EnumValueDescriptorExpression(*enum_descriptor.value(i));
    printer_->Print(e.c_str());
    printer_->Print(",\n");
  }
  printer_->Outdent();
  printer_->Outdent();
  printer_->Print("]);\n");
  printer_->Print("\n");
}

// Recursively prints enums in nested types within descriptor, then
// prints enums contained at the top level in descriptor.
void Generator::PrintNestedEnums(const Descriptor& descriptor) const {
  for (int i = 0; i < descriptor.nested_type_count(); ++i) {
    PrintNestedEnums(*descriptor.nested_type(i));
  }

  for (int i = 0; i < descriptor.enum_type_count(); ++i) {
    PrintEnum(*descriptor.enum_type(i));
  }
}

void Generator::PrintTopLevelExtensions() const {
  // TODO(bradfitz): implement extension output
  const bool is_extension = true;
  for (int i = 0; i < file_->extension_count(); ++i) {
    const FieldDescriptor& extension_field = *file_->extension(i);
    printer_->Print("# `name` = ", "name", extension_field.name());
    PrintFieldDescriptor(extension_field, is_extension, printer_);
    printer_->Print("\n");
  }
  printer_->Print("\n");
}

// Prints Perl equivalents of all Descriptors in |file|.
void Generator::PrintMessageDescriptors() const {
  for (int i = 0; i < file_->message_type_count(); ++i) {
    PrintDescriptor(*file_->message_type(i));
    printer_->Print("\n");
  }
}

// Prints statement assigning ModuleLevelDescriptorName(message_descriptor)
// to a Perl Descriptor object for message_descriptor.
//
// Mutually recursive with PrintNestedDescriptors().
void Generator::PrintDescriptor(const Descriptor& message_descriptor) const {
  PrintNestedDescriptors(message_descriptor);

  printer_->Print("\n");
  printer_->Print(
      "our $`descriptor_name` = Google::Net::Proto2::Descriptor->new(\n",
      "descriptor_name",
      ModuleLevelDescriptorName(message_descriptor));
  printer_->Indent();
  map<string, string> m;
  m["name"] = message_descriptor.name();
  m["full_name"] = message_descriptor.full_name();
  m["filename"] = message_descriptor.file()->name();
  const char required_function_arguments[] =
      "name => '`name`',\n"
      "full_name => '`full_name`',\n"
      "filename => '`filename`',\n"
      "containing_type => undef,\n";  // TODO(bradfitz): Implement containing_type.
  printer_->Print(m, required_function_arguments);
  PrintFieldsInDescriptor(message_descriptor, printer_);
  PrintExtensionsInDescriptor(message_descriptor, printer_);
  // TODO(bradfitz): implement printing of nested_types.
  printer_->Print("nested_types => [],  # TODO(bradfitz): Implement.\n");
  printer_->Print("enum_types => [\n");
  printer_->Indent();
  for (int i = 0; i < message_descriptor.enum_type_count(); ++i) {
    const string descriptor_name = ModuleLevelDescriptorName(
        *message_descriptor.enum_type(i));
    printer_->Print("$");
    printer_->Print(descriptor_name.c_str());
    printer_->Print(",\n");
  }
  printer_->Outdent();
  printer_->Print("],\n");
  PrintOptionsInDescriptor(message_descriptor, printer_);
  printer_->Outdent();
  printer_->Print(")\n");
}

// Prints Perl Descriptor objects for all nested types contained in
// message_descriptor.
//
// Mutually recursive with PrintDescriptor().
void Generator::PrintNestedDescriptors(
    const Descriptor& containing_descriptor) const {
  for (int i = 0; i < containing_descriptor.nested_type_count(); ++i) {
    PrintDescriptor(*containing_descriptor.nested_type(i));
  }
}

// Prints all messages in |file|.
void Generator::PrintMessages() const {
  string empty_prefix;
  for (int i = 0; i < file_->message_type_count(); ++i) {
    PrintMessage(empty_prefix, *file_->message_type(i));
    printer_->Print("\n");
  }
}

// Prints a Perl class for the given message descriptor.  We defer to the
// metaclass to do almost all of the work of actually creating a useful class.
// The purpose of this function and its many helper functions above is merely
// to output a Perl version of the descriptors, which the metaclass in
// Message.pm will use to construct the meat of the class itself.
//
// Mutually recursive with PrintNestedMessages().
void Generator::PrintMessage(
    const string& class_prefix,
    const Descriptor& message_descriptor) const {
  printer_->Print("Message->GenerateClass('`name`', ", "name",
                  class_prefix + message_descriptor.name());
  printer_->Print("$`descriptor_name`);\n",
                  "descriptor_name",
                  ModuleLevelDescriptorName(message_descriptor));

  // nested messages
  for (int i = 0; i < message_descriptor.nested_type_count(); ++i) {
    PrintMessage(class_prefix + message_descriptor.name() + "::",
                 *message_descriptor.nested_type(i));
  }
}

// Recursively fixes foreign fields in all nested types in |descriptor|, then
// sets the message_type and enum_type of all message and enum fields to point
// to their respective descriptors.
void Generator::FixForeignFieldsInDescriptor(
    const Descriptor& descriptor) const {
  for (int i = 0; i < descriptor.nested_type_count(); ++i) {
    FixForeignFieldsInDescriptor(*descriptor.nested_type(i));
  }

  for (int i = 0; i < descriptor.field_count(); ++i) {
    const FieldDescriptor& field_descriptor = *descriptor.field(i);
    FixForeignFieldsInField(&descriptor, field_descriptor, "fields_by_name");
  }
}

// Sets any necessary message_type and enum_type attributes
// for the Perl version of |field|.
//
// containing_type may be NULL, in which case this is a module-level field.
//
// perl_dict_name is the name of the Perl dict where we should
// look the field up in the containing type.  (e.g., fields_by_name
// or extensions_by_name).  We ignore perl_dict_name if containing_type
// is NULL.
void Generator::FixForeignFieldsInField(const Descriptor* containing_type,
                                        const FieldDescriptor& field,
                                        const string& perl_dict_name) const {
  // TODO(bradfitz): implement.  commented out now.
  const string field_referencing_expression = FieldReferencingExpression(
      containing_type, field, perl_dict_name);
  map<string, string> m;
  m["field_ref"] = field_referencing_expression;
  const Descriptor* foreign_message_type = field.message_type();
  if (foreign_message_type) {
    m["foreign_type"] = ModuleLevelDescriptorName(*foreign_message_type);
    printer_->Print(m, "`field_ref`->set_message_type($`foreign_type`);\n");
  }
  const EnumDescriptor* enum_type = field.enum_type();
  if (enum_type) {
    m["enum_type"] = ModuleLevelDescriptorName(*enum_type);
    printer_->Print(m, "`field_ref`->set_enum_type($`enum_type`);\n");
  }
}

// Returns the module-level expression for the given FieldDescriptor.
// Only works for fields in the .proto file this Generator is generating for.
//
// containing_type may be NULL, in which case this is a module-level field.
//
// perl_dict_name is the name of the Perl dict where we should
// look the field up in the containing type.  (e.g., fields_by_name
// or extensions_by_name).  We ignore perl_dict_name if containing_type
// is NULL.
string Generator::FieldReferencingExpression(
    const Descriptor* containing_type,
    const FieldDescriptor& field,
    const string& perl_dict_name) const {
  // We should only ever be looking up fields in the current file.
  // The only things we refer to from other files are message descriptors.
  GOOGLE_CHECK_EQ(field.file(), file_) << field.file()->name() << " vs. "
                                << file_->name();
  if (!containing_type) {
    return field.name();
  }
  return "$" + strings::Substitute(
      "$0->$1('$2')",
      ModuleLevelDescriptorName(*containing_type),
      perl_dict_name, field.name());
}

// Prints statements setting the message_type and enum_type fields in the
// Perl descriptor objects we've already output in ths file.  We must
// do this in a separate step due to circular references (otherwise, we'd
// just set everything in the initial assignment statements).
void Generator::FixForeignFieldsInDescriptors() const {
  for (int i = 0; i < file_->message_type_count(); ++i) {
    FixForeignFieldsInDescriptor(*file_->message_type(i));
  }
  printer_->Print("\n");
}

// We need to not only set any necessary message_type fields, but
// also need to call RegisterExtension() on each message we're
// extending.
void Generator::FixForeignFieldsInExtensions() const {
  // Top-level extensions.
  for (int i = 0; i < file_->extension_count(); ++i) {
    FixForeignFieldsInExtension(*file_->extension(i));
  }
  // Nested extensions.
  for (int i = 0; i < file_->message_type_count(); ++i) {
    FixForeignFieldsInNestedExtensions(*file_->message_type(i));
  }
}

void Generator::FixForeignFieldsInExtension(
    const FieldDescriptor& extension_field) const {
  // TODO(bradfitz): implement.  commented out.
  GOOGLE_CHECK(extension_field.is_extension());
  // extension_scope() will be NULL for top-level extensions, which is
  // exactly what FixForeignFieldsInField() wants.
  FixForeignFieldsInField(extension_field.extension_scope(), extension_field,
                          "extensions_by_name");

  map<string, string> m;
  // Confusingly, for FieldDescriptors that happen to be extensions,
  // containing_type() means "extended type."
  // On the other hand, extension_scope() will give us what we normally
  // mean by containing_type().
  m["extended_message_class"] = ModuleLevelMessageName(
      *extension_field.containing_type());
  m["field"] = FieldReferencingExpression(extension_field.extension_scope(),
                                          extension_field,
                                          "extensions_by_name");
  printer_->Print(m,
                  "# `extended_message_class`->RegisterExtension(`$field`);\n");
}

void Generator::FixForeignFieldsInNestedExtensions(
    const Descriptor& descriptor) const {
  // Recursively fix up extensions in all nested types.
  for (int i = 0; i < descriptor.nested_type_count(); ++i) {
    FixForeignFieldsInNestedExtensions(*descriptor.nested_type(i));
  }
  // Fix up extensions directly contained within this type.
  for (int i = 0; i < descriptor.extension_count(); ++i) {
    FixForeignFieldsInExtension(*descriptor.extension(i));
  }
}

// Returns the unique Perl module-level identifier given to a descriptor.
// This name is module-qualified iff the given descriptor describes an
// entity that doesn't come from the current file.
template <typename DescriptorT>
string Generator::ModuleLevelDescriptorName(
    const DescriptorT& descriptor) const {
  // FIXME(bradfitz,robinson):
  // We currently don't worry about collisions with underscores in the type
  // names, so these would collide in nasty ways if found in the same file:
  //   OuterProto.ProtoA.ProtoB
  //   OuterProto_ProtoA.ProtoB  # Underscore instead of period.
  // As would these:
  //   OuterProto.ProtoA_.ProtoB
  //   OuterProto.ProtoA._ProtoB  # Leading vs. trailing underscore.
  // (Contrived, but certainly possible).
  //
  // The C++ implementation doesn't guard against this either.  Leaving
  // it for now...
  string name = NamePrefixedWithNestedTypes(descriptor, "_");
  UpperString(&name);
  // Module-private for now.  Easy to make public later; almost impossible
  // to make private later.
  name = "_" + name;
  // We now have the name relative to its own module.  Also qualify with
  // the module name iff this descriptor is from a different .proto file.
  if (descriptor.file() != file_) {
    name = PackageName(descriptor.file()->name()) + "::" + name;
  }
  return name;
}

// Returns the name of the message class itself, not the descriptor.
// Like ModuleLevelDescriptorName(), module-qualifies the name iff
// the given descriptor describes an entity that doesn't come from
// the current file.
string Generator::ModuleLevelMessageName(const Descriptor& descriptor) const {
  string name = NamePrefixedWithNestedTypes(descriptor, ".");
  if (descriptor.file() != file_) {
    name = PackageName(descriptor.file()->name()) + "." + name;
  }
  return name;
}

}  // namespace perl
}  // namespace compiler
}  // namespace protobuf
}  // namespace google


