=head1 NAME

XML::Filter::Recorder::Store::FH - Filehandle based storage for SAX event recorder

=head1 SYNOPSIS

 use XML::Filter::Recorder::Store::FH;

 $store = XML::Filter::Recorder::Store::FH->new($fh);

=head1 DESCRIPTION

This module implements a storage for XML::Filter::Recorder that stores data to
a filehandle.

=head1 CONSTRUCTOR

=over

=item $store = XML::Filter::Recorder::Store::FH->new($fh);

Takes a single argument, the filehandle to work with.  The filehandle can be
opened in read and/or write mode - which will effect whether the store can be
used for read and/or writing events.

=cut
package XML::Filter::Recorder::Store::FH;

require 5.006;
use strict;
use warnings;

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my ($fh) = @_;

	my $self = \$fh;
	bless $self, $class;

	return $self;
}

sub store {
	my $self = shift;
	my ($string) = @_;

	my $out = pack("La*", length($string), $string);

	print {$$self} $out;
}

sub retrieve {
	my $self = shift;

	eof($$self) and return undef;

	my $buff;
	read($$self, $buff, 4) == 4
		or die "Invalid cached data stream";
	
	my $length = unpack("L", $buff);
	read($$self, $buff, $length) == $length
		or die "Invalid cached data stream";
	
	my $string = unpack("a*", $buff);
	return $string;
}

sub rewind {
	my $self = shift;
	seek $$self, 0, 0;
}


1;
__END__

=back

=head1 SEE ALSO

XML::Filter::Recorder

=head1 AUTHOR

Chris Leishman <chris@leishman.org>

=head1 COPYRIGHT

Copyright (C) 2006 Chris Leishman.  All Rights Reserved.

This module is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY KIND,
either expressed or implied. This program is free software; you can
redistribute or modify it under the same terms as Perl itself.

$Id: FH.pm,v 1.4 2006/02/06 06:01:12 caleishm Exp $

=cut
