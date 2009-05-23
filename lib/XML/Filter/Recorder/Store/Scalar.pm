=head1 NAME

XML::Filter::Recorder::Store::Scalar - Scalar based storage for SAX event recorder

=head1 SYNOPSIS

 use XML::Filter::Recorder::Store::Scalar;

 $store = XML::Filter::Recorder::Store::Scalar->new($scalarref);

=head1 DESCRIPTION

This module implements a storage for XML::Filter::Recorder that stores data to
a scalar reference.

=head1 CONSTRUCTOR

=over

=item $store = XML::Filter::Recorder::Store::Scalar->new($scalarref);

Takes a single argument, the scalar reference to work with.

=cut
package XML::Filter::Recorder::Store::Scalar;

require 5.006;
use strict;
use warnings;

use fields qw(scalar offset);

sub new {
	my $self = shift;
	my ($scalar) = @_;

	$self = fields::new($self) unless ref $self;

	$$scalar ||= '';
	$self->{scalar} = $scalar;
	$self->{offset} = 0;

	return $self;
}

sub store {
	my $self = shift;
	my ($string) = @_;
	my $scalar = $self->{scalar};

	# truncate array and add entry
	if (length($scalar) >= $self->{offset}) {
		substr($$scalar, $self->{offset}) = '';
	}
	$$scalar .= pack("La*", length($string), $string);
	$self->{offset} = length($$scalar);
}

sub retrieve {
	my $self = shift;
	my $scalar = $self->{scalar};

	length($$scalar) > $self->{offset} or return undef;

	my $length = unpack("L", substr($$scalar, $self->{offset}, 4));
	$self->{offset} += 4;

	length($$scalar) >= $self->{offset} + $length
		or die "Invalid cache store";
	my $string = substr($$scalar, $self->{offset}, $length);
	$self->{offset} += $length;
	return $string;
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

$Id: Scalar.pm,v 1.4 2006/02/06 06:01:12 caleishm Exp $

=cut
