package Synapse::Request::CreateProject;

# A package representing a Synapse request, suitable
# for feeding into Synapse::WebClient::post()

use Carp;
use Data::Dumper;
use namespace::autoclean;

use Moose;
extends qw(Synapse::Request);
use MooseX::ClassAttribute;

has uri => (is=>'ro', isa=>'Str', default=>'https://repo-alpha.sagebase.org/repo/v1/entity');
has fields =>     (is=>'ro', isa=>'HashRef', default=>sub{{
    name=>'COmplicated test',
    entityType=>'org.sagebionetworks.repo.model.Project',
    description=>'Test project for ISB COMPLICATED project by John Earles, Victor Cassen',
    }});
has project_fn_base => (is=>'ro', isa=>'Str', default=>'.project');

sub post_hook {
    my ($self, $json)=@_;
    warn "CP:post_hook: json is ",Dumper($json);

    my $project_id=$json->{id} or confess "no (project) id in ", Dumper($json);
    my $project_fn=join('.', $self->project_fn_base, $project_id);
    open (PROJECT, ">$project_fn") or die "Unable to open $project_fn for writing: $!\n";
    print PROJECT $json;
    close PROJECT;
    warn "$project_fn written\n";
    $json;
}

__PACKAGE__->meta->make_immutable;

1;
