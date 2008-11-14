package Net::GeoPlanet;

use strict;
use LWP;
use URI;
use XML::Simple;

=head1 NAME

Net::GeoPlanet - Access Yahoo's GeoPlanet location service

=head1 SYNOPSIS

use Net::GeoPlanet;
use Data::Dumper;

my $geo = Net::GeoPlanet->new(api_key => $api_key);

print Dumper($geo->location("Woodside, NY 11377"));

=head1 ABOUT

Yahoo! GeoPlanet helps bridge the gap between the real and virtual worlds by
providing an open, permanent, and intelligent infrastructure for
geo-referencing data on the Internet.

For more information see http://developer.yahoo.com/geo/

=head1 BUGS

None known

=head1 AUTHOR

Written by Steven Kreuzer <skreuzer@exit2shell.com>

=head1 COPYRIGHT

Copyright 2008 - Steven Kreuzer

=cut

our $VERSION = '0.1';
our $QUERY_API_URL = 'http://where.yahooapis.com/v1/';
our @required_params = qw(api_key);

sub new {
    my $proto  = shift;
    my $class  = ref $proto || $proto;
    my %params = @_;
    my $client = bless \%params, $class;

    # Verify arguments
    $client->_check;

    $client->{browser} = LWP::UserAgent->new;

    return $client;
}

sub _check {
    my $self = shift;
    foreach my $param ( @required_params ) {
        if ( not defined $self->{$param} ) {
            die "Missing required parameter '$param'";
        }
    }
}

sub location {
	my $self = shift;
	my $place = shift;
	my $url = $QUERY_API_URL;
	$url .= 'places.q(\'' . $place . '\')?appid=' . $self->{api_key};
	return $self->_make_request($url, 'get');
}

sub _make_request {
	my $self = shift;
	my $url = shift;
	my $method = shift;

	my $u = URI->new($url);
	my $xml = XML::Simple->new();

	my $response = $self->{browser}->$method($u, 'Accept' => "application/xml");
	die "$method on $url failed: " . $response->status_line
		unless ( $response->is_success );

	return $xml->XMLin($response->content);
}
