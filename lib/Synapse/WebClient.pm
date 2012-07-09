package Synapse::WebClient;
use Carp;
use Data::Dumper;

use Moose;
use MooseX::ClassAttribute;
use LWP::UserAgent;
use JSON;
use PhonyBone::FileUtilities qw(warnf);
use namespace::autoclean;

has ua=>(is=>'ro', isa=>'LWP::UserAgent', default=>sub{new LWP::UserAgent()});
has session_token => (is=>'ro', isa=>'Str', lazy=>1, builder=>'read_session_token');
has session_token_file=>(is=>'ro', isa=>'Str', default=>'.session');

sub post {
    my ($self, $sr)=@_;
    warnf "uri: %s\n", $sr->uri;
    my $req=$sr->http_request();

    my $res=$self->ua->request($req);
    warn $res->status_line, "\n\n";
    warn "response: ", Dumper($res) if $ENV{DEBUG};

    my $hook_retval;
    if (! $res->is_error) {
	if (my $subref=$sr->can('post_hook')) {
	    my $json=from_json($res->content, {ascii=>1, pretty=>1});
	    $hook_retval=$subref->($sr, $json);
	}
    } else {
	open(ERRORS, ">errors");
	print ERRORS $res->content;
	close ERRORS;
	warn "content written to file 'errors'\n";
    }

    $hook_retval || $res;
}


sub read_session_token {
    my ($self)=@_;
    my $st_fn=$self->session_token_file;
    open(FILE, $st_fn) or return undef;
    my $st=<FILE>;
    chomp $st;
    close FILE;
    return $st;
}

__PACKAGE__->meta->make_immutable;

1;
