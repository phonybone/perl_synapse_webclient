package Synapse::Request::Login;

# A package representing a Synapse request, suitable
# for feeding into Synapse::WebClient::post()

use Carp;
use Data::Dumper;

use Moose;
use Synapse::Request;
extends qw(Synapse::Request);
use MooseX::ClassAttribute;
use namespace::autoclean;

has uri => (is=>'ro', isa=>'Str', default=>'https://auth-prod.sagebase.org/auth/v1/session');
has fields =>     (is=>'ro', isa=>'HashRef', default=>sub{
    {email=>'phonybone@gmail.com',
     password=>'Bsa441'}});
has needs_session_token => (is=>'ro', isa=>'Int', default=>'0');

# write session token file
# returns session token
sub post_hook {
    my ($self, $json)=@_;
    my $session_token=$json->{sessionToken} or confess "no sessionToken in ", Dumper($json);

    my $sn_fn=$self->web_client->session_token_file;
    open(FILE, ">$sn_fn") or die "Unable to open $sn_fn for writing: $!\n";
    print FILE $session_token;
    close FILE;
    warn "$sn_fn written\n";
    return $session_token;
}

__PACKAGE__->meta->make_immutable;

1;
