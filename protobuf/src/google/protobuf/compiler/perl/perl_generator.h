// Copyright 2008 Google Inc. All Rights Reserved.
// Author: bradfitz@google.com (Brad Fitzpatrick)

#ifndef GOOGLE_PROTOBUF_COMPILER_PERL_PUBLIC_GENERATOR_H__
#define GOOGLE_PROTOBUF_COMPILER_PERL_PUBLIC_GENERATOR_H__

#include <string>

#include <google/protobuf/compiler/code_generator.h>
#include <google/protobuf/stubs/common.h>

namespace google {
namespace protobuf {

class Descriptor;
class EnumDescriptor;
class FieldDescriptor;

namespace io { class Printer; }

namespace compiler {
namespace perl {

// CodeGenerator implementation for generated Perl protocol buffer classes.
// If you create your own protocol compiler binary and you want it to support
// Perl output, you can do so by registering an instance of this
// CodeGenerator with the CommandLineInterface in your main() function.
class LIBPROTOC_EXPORT Generator : public CodeGenerator {
 public:
  Generator();
  virtual ~Generator();

  // CodeGenerator methods.
  virtual bool Generate(const FileDescriptor* file,
                        const string& parameter,
                        OutputDirectory* output_directory,
                        string* error) const;

 private:
  void PrintImports() const;
  void PrintTopLevelEnums() const;
  void PrintAllNestedEnumsInFile() const;
  void PrintNestedEnums(const Descriptor& descriptor) const;
  void PrintEnum(const EnumDescriptor& enum_descriptor) const;

  void PrintTopLevelExtensions() const;

  void PrintMessageDescriptors() const;
  void PrintDescriptor(const Descriptor& message_descriptor) const;
  void PrintNestedDescriptors(const Descriptor& containing_descriptor) const;

  void PrintMessages() const;
  void PrintMessage(const string& class_prefix,
                    const Descriptor& message_descriptor) const;

  void FixForeignFieldsInDescriptors() const;
  void FixForeignFieldsInDescriptor(const Descriptor& descriptor) const;
  void FixForeignFieldsInField(const Descriptor* containing_type,
                               const FieldDescriptor& field,
                               const string& perl_dict_name) const;
  string FieldReferencingExpression(const Descriptor* containing_type,
                                    const FieldDescriptor& field,
                                    const string& perl_dict_name) const;

  void FixForeignFieldsInExtensions() const;
  void FixForeignFieldsInExtension(
      const FieldDescriptor& extension_field) const;
  void FixForeignFieldsInNestedExtensions(const Descriptor& descriptor) const;

  template <typename DescriptorT>
  string ModuleLevelDescriptorName(const DescriptorT& descriptor) const;
  string ModuleLevelMessageName(const Descriptor& descriptor) const;

  // Very coarse-grained lock to ensure that Generate() is reentrant.
  // Guards file_ and printer_.
  mutable Mutex mutex_;
  mutable const FileDescriptor* file_;  // Set in Generate().  Under mutex_.
  mutable io::Printer* printer_;  // Set in Generate().  Under mutex_.

  GOOGLE_DISALLOW_EVIL_CONSTRUCTORS(Generator);
};

}  // namespace perl
}  // namespace compiler
}  // namespace protobuf
}  // namespace google

#endif  // GOOGLE_PROTOBUF_COMPILER_PERL_PUBLIC_GENERATOR_H__

