=head1 NAME

XML::Filter::Recorder::Store - Interface to storage object for SAX event recorder

=head1 SYNOPSIS

 use XML::Filter::Recorder::Store;

 our @ISA = qw(XML::Filter::Recorder::Store);

 sub store { ... }
 sub retrieve { ... }
 sub playback { ... }

=head1 DESCRIPTION

This module defines the interface for a Storage object used by
XML::Filter::Recorder (a recorder for SAX2 events).

=head1 METHODS

The following methods must be implemented by a concrete class.

=over

=cut
package XML::Filter::Recorder::Store;

require 5.006;
use strict;
use warnings;

=item $s->store($string)

Store the string.  If the rewind() method has previously been called, this
will truncate all following entries in the store.

=cut

sub store;

=item $string = $s->retrieve($string)

Retrieves the next item from the store.

=cut

sub retrieve;

=item $s->rewind()

Rewinds the store to the beginning.  This means that calls to retrieve will
begin from the start again, and any following call to the store method will
truncate the storage.

=cut

sub rewind;

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

$Id: Store.pm,v 1.4 2006/02/06 06:01:12 caleishm Exp $

=cut
