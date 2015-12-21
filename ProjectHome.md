Protocol Buffers for Perl.

Work in progress.

Status as of 2007-07-30:

**Working:**

  * protoc (C++) changes required to emit auto-generated Perl
  * Moose code to use that auto-generated Perl and make classes from all messages
  * parsing the stream, decoding aggregates, strings, all numbers
  * encoding everything, including all number formats
  * bunch of tests
  * everything(?) that we need for the Perl App Engine project now.

**Not working:**

  * extensions (haven't worked on it)
  * imports (should be working? but no tests.)
  * dynamic parsing .proto files (without the C++ protoc compiler)  Perl App Engine doesn't need this, so low priority.  But some Perl users want this.  Future.