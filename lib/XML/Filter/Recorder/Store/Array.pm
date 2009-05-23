=head1 NAME

XML::Filter::Recorder::Store::Array - Array based storage for SAX event recorder

=head1 SYNOPSIS

 use XML::Filter::Recorder::Store::Array;

 $store = XML::Filter::Recorder::Store::Array->new($arrayref);

=head1 DESCRIPTION

This module implements a storage for XML::Filter::Recorder that stores data to
a array reference.

=head1 CONSTRUCTOR

=over

=item $store = XML::Filter::Recorder::Store::Array->new($arrayref);

Takes a single argument, the array reference to work with.

=cut
package XML::Filter::Recorder::Store::Array;

require 5.006;
use strict;
use warnings;

use fields qw(array offset);

sub new {
	my $self = shift;
	my ($array) = @_;

	$self = fields::new($self) unless ref $self;

	$self->{array} = $array;
	$self->{offset} = 0;

	return $self;
}

sub store {
	my $self = shift;
	my ($string) = @_;
	my $array = $self->{array};

	# truncate array and add entry
	splice(@$array, $self->{offset}++);
	push(@$array, $string);
}

sub retrieve {
	my $self = shift;
	my $array = $self->{array};

	return $$array[$self->{offset}++];
}

sub rewind {
	my $self = shift;
	$self->{offset} = 0;
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

$Id: Array.pm,v 1.4 2006/02/06 06:01:12 caleishm Exp $

=cut
