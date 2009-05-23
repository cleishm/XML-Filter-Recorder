use Test::More tests => 4;

use XML::SAX;
use XML::SAX::Writer;
use XML::Filter::Recorder;

my $output;
my $cache;
my $writer = XML::SAX::Writer->new(Output => \$output);
my $recorder = XML::Filter::Recorder->new(
	Handler => $writer,
	Store => \$cache
	);
local $XML::SAX::ParserPackage = "XML::SAX::PurePerl";
my $parser = XML::SAX::ParserFactory->parser(Handler => $recorder);
$parser->parse_string("<foo />", Handler => $recorder);

ok($output, "output occured");
ok($cache, "events were recorded to scalar");

# prepare for playback
$output2 = '';
$writer = XML::SAX::Writer->new(Output => \$output2);

$recorder->set_handler(Handler => $writer);

$recorder->playback();

ok($output2, "output occured after playback");
is($output2, $output, "playback output matches original");
