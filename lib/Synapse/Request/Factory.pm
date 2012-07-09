package Synapse::Request::Factory;
use Carp;
use Data::Dumper;

use Moose;
use MooseX::ClassAttribute;
use namespace::autoclean;

has cmd2class=>(is=>'ro', isa=>'HashRef', default=>sub {{
    create_user=>'CreateUser',
    login=>'Login',
    create_project=>'CreateProject',
    fetch=>'FetchEntity',
    search=>'SearchEntities',
    delete_entity=>'DeleteEntity',
}});
    
has base_class=>(is=>'ro', isa=>'Str', default=>'Synapse::Request');
has web_client=>(is=>'ro', isa=>'Synapse::WebClient', required=>1);

sub new_request {
    my ($self, $cmd, $params)=@_;
    my $subclass=$self->cmd2class->{$cmd} or return undef;
    my $full_class=join('::', $self->base_class, $subclass);
    eval "require $full_class";
    die "require $full_class: $@\n" if $@;
    $full_class->new(web_client=>$self->web_client, %$params);
}

__PACKAGE__->meta->make_immutable;


1;
