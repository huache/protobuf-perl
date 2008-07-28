use strict;
use ExtUtils::MakeMaker;
WriteMakefile('NAME' => 'Protobuf',
              'VERSION_FROM' => 'lib/Protobuf.pm',
              'PREREQ_PM' => {
                  'Moose' => 0,
                  'MooseX::Policy' => 0,
              });

