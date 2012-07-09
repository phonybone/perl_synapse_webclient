package Synapse::Request::DeleteEntity;

# A package representing a Synapse request, suitable
# for feeding into Synapse::WebClient::post()

use Carp;
use Data::Dumper;
use namespace::autoclean;

use Moose;
extends qw(Synapse::Request);
use MooseX::ClassAttribute;

has entity_id => (is=>'ro', isa=>'Str', required=>1);
has uri_base => (is=>'ro', isa=>'Str', default=>'https://repo-alpha.sagebase.org/repo/v1/entity');
has uri => (is=>'ro', lazy=>1, builder=>'_build_uri');
has fields =>     (is=>'ro', isa=>'HashRef', default=>sub{{}});
has method=>     (is=>'ro', isa=>'Str', default=>'DELETE');

sub _build_uri {
    my ($self)=@_;
    join('/', $self->uri_base, $self->entity_id);
}

sub post_hook {
    my ($self, $json)=@_;
    warn $self->entity_id, " deleted\n";
}

__PACKAGE__->meta->make_immutable;

1;
