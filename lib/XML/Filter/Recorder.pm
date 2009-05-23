=head1 NAME

XML::Filter::Recorder - SAX event recorder

=head1 SYNOPSIS

 use XML::Filter::Recorder;

 $recorder = XML::Filter::Recorder->new(
                  Source => $fh, Handler => $next_handler);
 $parser->set_handler(Handler => $recorder);
 $parser->parse($document);

 $recorder->playback();

=head1 DESCRIPTION

This module implements a recorder for SAX2 events.  It is similar to Matt
Sergeant's XML::Filter::Cache which serializes each SAX event separately using
Storable and records them for later playback.

=head1 METHODS

A SAX recorder supports all the methods of a typical SAX filter, as well as a
playback() method which will replay recorded events to downstream handlers.

=over

=cut
package XML::Filter::Recorder;

require 5.006;
use strict;
use warnings;
use XML::SAX::EventMethodMaker qw(sax_event_names compile_missing_methods);
use Storable qw(nfreeze thaw);
use Carp;

use base qw(XML::SAX::Base);

our $VERSION = '1.00';


=item my $r = XML::Filter::Recorder->new(Store => $store)

Constructs a new recorder.  Serialized events are recorded to $store, which
may be a filehandle, filename (in which case the file is opened for
read/write), string reference, array reference or any object that conforms to
the XML::Filter::Recorder::Store interface.  If the Store is not provided, then
an anonymous array reference is used for storage of events.

=cut

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my $args = $#_? { @_ } : { Store => shift };

	# use an anonymous array ref if nothing else
	my $store = $$args{Store} || [];

	delete $$args{Store};
	
	# recognize known store base types
	unless (ref($store)) {
		# scalar - treat as a filename
		require XML::Filter::Recorder::Store::File;
		my $filename = $store;
		$store = XML::Filter::Recorder::Store::File->new($filename)
			or croak "Failed to open $filename: $!";
	}
	elsif (ref($store) eq 'SCALAR') {
		# scalar ref
		require XML::Filter::Recorder::Store::Scalar;
		$store = XML::Filter::Recorder::Store::Scalar->new($store);
	}
	elsif (ref($store) eq 'ARRAY') {
		# scalar ref
		require XML::Filter::Recorder::Store::Array;
		$store = XML::Filter::Recorder::Store::Array->new($store);
	}
	elsif ($store->isa('XML::Filter::Recorder::Store')) {
		# already a Store object - ignore
	}
	elsif (ref($store) eq 'GLOB' or
	       UNIVERSAL::isa($store, 'GLOB') or
	       UNIVERSAL::isa($store, 'IO::Handle'))
	{
		# handle
		require XML::Filter::Recorder::Store::FH;
		$store = XML::Filter::Recorder::Store::FH->new($store);
	}
	else {
		croak "Cannot handle reference type ".ref($store).
		      " as a Store object during Recorder init";
	}

	my $self = $class->SUPER::new($args);
	bless $self, $class;

	$self->{SAXRecorderStore} = $store;

	return $self;
}

# record a sax event
sub record {
	my $self = shift;
	my $frozen = nfreeze(\@_);
	$self->{SAXRecorderStore}->store($frozen);

}

=item $r->playback()

Causes all recorded events to be replayed to downstream handlers.

=cut

sub playback {
	my $self = shift;
	my $io = $self->{SAXRecorderStore};

	$io->rewind();

	my $ret;
	while (my $frozen = $io->retrieve()) {
		my ($method, @args) = @{thaw($frozen)};
		my $supermethod = "SUPER::$method";
		$ret = $self->$supermethod(@args);
	}
	# return result of end_document
	return $ret;
}

# cause end_document to rewind the Store object
sub end_document {
	my $self = shift;
	$self->record(end_document => $_[0]);
	$self->{SAXRecorderStore}->rewind();
	return $self->SUPER::end_document(@_);
}

# this method gets passed code refs that Storable barfs on, so expand them
sub set_document_locator {
	my $self = shift;
	$self->record(set_document_locator => { %{$_[0]} });
	return $self->SUPER::set_document_locator(@_);
}

compile_missing_methods 'XML::Filter::Recorder', <<'EOT', sax_event_names;
sub <EVENT> {
	my $self = shift;
	$self->record(<EVENT> => $_[0]);
	return $self->SUPER::<EVENT>(@_);
}
EOT


1;
__END__

=back

=head1 SEE ALSO

XML::Filter::Cache

=head1 AUTHOR

Chris Leishman <chris@leishman.org>

=head1 COPYRIGHT

Copyright (C) 2006 Chris Leishman.  All Rights Reserved.

This module is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY KIND,
either expressed or implied. This program is free software; you can
redistribute or modify it under the same terms as Perl itself.

$Id: Recorder.pm,v 1.5 2006/02/06 06:01:11 caleishm Exp $

=cut
