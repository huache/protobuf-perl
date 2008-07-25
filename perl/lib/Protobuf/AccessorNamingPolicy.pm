package Protobuf::AccessorNamingPolicy;

use constant attribute_metaclass => 'Protobuf::AccessorNamingPolicy::Attribute';

package Protobuf::AccessorNamingPolicy::Attribute;
use Moose;

extends 'Moose::Meta::Attribute';

before '_process_options' => sub {
    my ($class, $name, $options) = @_;
    # NOTE:
    # If is has been specified, and 
    # we don't have a reader or writer
    # Of couse this is an odd case, but
    # we better test for it anyway.
    if (exists $options->{is} && !(exists $options->{reader} || exists $options->{writer})) {
        if ($options->{is} eq 'ro') {
            $options->{reader} = $name;
        }
        elsif ($options->{is} eq 'rw') {
            $options->{reader} = $name;
            $options->{writer} = 'set_' . $name;
        }
        delete $options->{is};
    }
};

1;
