use Test::More tests => 3;

use XML::SAX;
use XML::SAX::Writer;
use XML::Filter::Recorder;
use File::Temp qw(tempfile);

my $output;
my $fh = tempfile();

my $writer = XML::SAX::Writer->new(Output => \$output);
my $recorder = XML::Filter::Recorder->new(
	Handler => $writer,
	Store => $fh, 
	);
local $XML::SAX::ParserPackage = "XML::SAX::PurePerl";
my $parser = XML::SAX::ParserFactory->parser(Handler => $recorder);
$parser->parse_string("<foo />", Handler => $recorder);

ok($output, "output occured");

# prepare for playback
$output2 = '';
$writer = XML::SAX::Writer->new(Output => \$output2);

$recorder->set_handler(Handler => $writer);

$recorder->playback();

ok($output2, "output occured after playback");
is($output2, $output, "playback output matches original");
