use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'XML::Filter::Recorder',
    'VERSION_FROM'	=> 'lib/XML/Filter/Recorder.pm', # finds $VERSION
    'AUTHOR'		=> 'Chris Leishman <chris@leishman.org>',
    'PREREQ_PM'		=> {
        XML::SAX			=> 0.12,
        XML::SAX::EventMethodMaker	=> 0.1,
        XML::SAX::Writer		=> 0.42,
        Test::More			=> 0.47,
     },
);
