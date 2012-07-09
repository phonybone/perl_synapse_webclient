package Synapse::Request::SearchEntities;

# A package representing a Synapse request, suitable
# for feeding into Synapse::WebClient::post()

use Carp;
use Data::Dumper;
use URI::Escape;
use namespace::autoclean;

use Moose;
extends qw(Synapse::Request);

has search_terms =>  (is=>'ro', isa=>'ArrayRef', required=>1);
has return_fields => (is=>'ro', isa=>'ArrayRef', default=>sub { [qw(id name)] });

has uri_base =>      (is=>'ro', isa=>'Str', default=>'https://repo-alpha.sagebase.org/repo/v1/search');
has uri =>           (is=>'ro', lazy=>1, builder=>'_build_uri');
has method=>         (is=>'ro', isa=>'Str', default=>'GET');

around BUILDARGS => sub {
    my $orig=shift;
    my $class=shift;
    my %args=@_;

    if ($args{search_terms}) {
	if (ref $args{search_terms} ne 'ARRAY') {
	    $args{search_terms}=[split(/,/, $args{search_terms})];
	}
    }
    if ($args{return_fields}) {
	if (ref $args{return_fields} ne 'ARRAY') {
	    $args{return_fields}=[split(/,/, $args{return_fields})];
	}
    }

    return $class->$orig(%args);
};

sub _build_uri {
    my ($self)=@_;
    my $search_terms=join('=', 'q', join(',', @{$self->search_terms}));
    my $return_fields=join('=', 'return-fields', join(',', @{$self->return_fields}));
    my $suffix=join('&', $search_terms, $return_fields);
    join('?q=', $self->uri_base, uri_escape($suffix));
}


__PACKAGE__->meta->make_immutable;

1;
