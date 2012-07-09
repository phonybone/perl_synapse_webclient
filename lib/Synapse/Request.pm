package Synapse::Request;

# A package representing a Synapse request, suitable
# for feeding into Synapse::WebClient::post()

use Carp;
use Data::Dumper;
use JSON;

use Moose;
use MooseX::ClassAttribute;
use namespace::autoclean;

has uri=>        (is=>'ro', isa=>'Str', required=>1);
has fields=>     (is=>'ro', isa=>'HashRef', default=>sub{{}});
has web_client=> (is=>'ro', isa=>'Synapse::WebClient', required=>1);
has needs_session_token => (is=>'ro', isa=>'Int', default=>1);
has method=>     (is=>'ro', isa=>'Str', default=>'POST');


sub http_request {
    my ($self)=@_;
    my $req=HTTP::Request->new($self->method, $self->uri);

    if (keys %{$self->fields}) {
	my $fields=to_json(\%{$self->fields});
	$req->content($fields);
    }

    $req->header('Content-Type', 'application/json');
    $req->header('Accept', 'application/json');
    $req->header('sessionToken', $self->web_client->session_token)
	if ($self->needs_session_token);

    $req;
}

sub post_hook {
    my ($self, $json)=@_;
    $json;
}

__PACKAGE__->meta->make_immutable;

1;
