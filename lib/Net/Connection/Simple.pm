package Net::Connection::Simple;

use 5.008007;
use strict;
use warnings;

use Time::Timestamp;

our $VERSION = '1.01';

# CONSTRUCTOR
sub new {
	my ($class,%data) = @_;
	my $self = {};
	bless($self,$class);
	$self->init(%data);
	return $self;
}

#INIT
sub init {
	my ($self,%data) = @_;
	$self->protocols(	$data{protocols});
	$self->seenFirst(	$data{seenFirst});
	$self->seenLast(	$data{seenLast});
}

# METHODS


# ACCESSORS / MODIFIERS

sub start {
	my ($self,$v) = @_;
	$self->{_start} = Time::Timestamp->new(ts => $v) if(defined($v));
	return $self->{_start};
}

sub end {
	my ($self,$v) = @_;
	$self->{_end} = Time::Timestamp->new(ts => $v) if(defined($v));
	return $self->{_end};
}

sub seenFirst {
	my ($self,$v) = @_;
	$self->{_seenFirst} = Time::Timestamp->new(ts => $v) if(defined($v));
	return $self->{_seenFirst};
}

sub seenLast {
	my ($self,$v) = @_;
	$self->{_seenLast} = Time::Timestamp->new(ts => $v) if(defined($v));
	return $self->{_seenLast};
}
#--------------
# values:	Hashref or Net::Protocol::Simple
# purpose:	Stores the different protocol layers for a connection
sub protocols {
	my ($self,$v) = @_;
	if(defined($v)){
		if(ref($v) eq 'HASHREF'){
			foreach my $x (keys %$v){ $self->protocols($v);}
		}
		if(!(ref($v) =~ /Net::Protocol::Simple/)){
			$self->errstr('Protocols requires a Net::Protocol::Simple Obj to be passed!');
			return undef;
		}
		$self->{_protocols}->{$v->layer()} = $v;
	}
	return $self->{_protocols};
}

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Net::Connection::Simple - Perl extension handling simple connection info within an application

=head1 SYNOPSIS

  use Net::Connection::Simple;
  my $c = Net::Connection::Simple->new(seenFirst => (time()-1800), seenLast => time());
  $c->protocols(Net::Protocol::Simple->new(protocol => tcp, layer => 4));
  $c->protocols(Net::Protocol::Simple->new(protocol => 'ip', layer => 3));
  $c->protocols(Net::Protocol::Simple->new(protocol => 'irc', layer => 7));

=head1 DESCRIPTION

  This module created to handle simple information about connections.

=head1 OBJECT METHODS

=head2 new

  Constructs the Connection object with the following properties:
  	protocol: 	protocol (will accept 1,6 and 17 for ICMP,TCP,UDP) [string]
  	layer: 		layer in the OSI model that the protocol resides [int]
	start:		connection start [see Time::Timestamp]
	end:		connection end [see Time::Timestamp]
  	seenFirst: 	first instance of the connection [See Time::Timestamp]
  	seenLast: 	last instance of the connection seen [See Time::Timestamp]

=head2 Time Properties

  [start|end|seenFirst|seenLast] will all return a Time::Timestamp object

=head2 protocols

  Returns a HASHREF of the protocols composing the connection [See Net::Protocol::Simple]

=head1 SEE ALSO

Net::Protocol::Simple, Time::Timestamp

=head1 AUTHOR

Wes Young, E<lt>saxguard9-cpan@yahoo.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2006 by Wes Young

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.7 or,
at your option, any later version of Perl 5 you may have available.


=cut
