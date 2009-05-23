=head1 NAME

XML::Filter::Recorder::Store::File - File based storage for SAX event recorder

=head1 SYNOPSIS

 use XML::Filter::Recorder::Store::File;

 $store = XML::Filter::Recorder::Store::File->new($filename);

=head1 DESCRIPTION

This module implements a storage for XML::Filter::Recorder that stores data to
a filehandle.

=head1 CONSTRUCTOR

=over

=item $store = XML::Filter::Recorder::Store::File->new($filename);

Takes a single argument, the name of the file to be opened and used.  If needs
be the file is created, using permissions of 0666 modified by the "umask"
value.  Returns undef (setting $!) if an open error occurs.

=cut
package XML::Filter::Recorder::Store::File;

require 5.006;
use strict;
use warnings;
use Symbol;

use base qw(XML::Filter::Recorder::Store::FH);


sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my ($filename) = @_;

	my $fh = Symbol::gensym();
	open($fh, '+<', $filename)
		or return undef;

	my $self = $class->SUPER::new($fh);
	bless $self, $class;

	return $self;
}

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

$Id: File.pm,v 1.4 2006/02/06 06:01:12 caleishm Exp $

=cut
