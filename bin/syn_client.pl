#!/usr/bin/env perl 
use strict;
use warnings;
use Carp;
use Data::Dumper;
use Options;			# PhonyBone::Options, sorta

use FindBin qw($Bin);
use Cwd 'abs_path';
use lib abs_path("$Bin/../lib");
use Synapse::WebClient;
use Synapse::Request::Factory;

BEGIN: {
    Options::use(qw(d q v h fuse=i));
    Options::get();
    die Options::usage() if $options{h};
    $ENV{DEBUG} = 1 if $options{d};
}

sub main {
    my @args=@_;
    my $cmd=shift @args or die "no cmd\n";
    my %params=@args;

    my $swc=Synapse::WebClient->new();
    my $factory=Synapse::Request::Factory->new(web_client=>$swc);
    my $sr=$factory->new_request($cmd, \%params) or 
	die "unknown command '$cmd'\n";
    my $obj=$swc->post($sr);
    warn "returned: ", Dumper($obj);
}


main(@ARGV);

