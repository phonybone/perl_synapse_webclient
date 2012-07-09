package Synapse::Request::CreateUser;

# A package representing a Synapse request, suitable
# for feeding into Synapse::WebClient::post()

use Carp;
use Data::Dumper;
use namespace::autoclean;

use Moose;
extends qw(Synapse::Request);
use MooseX::ClassAttribute;

has uri=> (is=>'ro', isa=>'Str', default=>'https://auth-staging.sagebase.org/auth/v1/user');
has fields=>     (is=>'ro', isa=>'HashRef', default=>sub{
    {email=>'phonybone@gmail.com',
     password=>'Bsa441'}});

__PACKAGE__->meta->make_immutable;

1;
