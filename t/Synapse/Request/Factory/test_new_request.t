#!/usr/bin/env perl 
#-*-perl-*-

# Tests the ability of Synapse::Request::Factory to build
# (synapse) request objects and the HTTP::Request objects 
# built on top of them.

use strict;
use warnings;
use Carp;
use Data::Dumper;
use Options;
use PhonyBone::FileUtilities qw(warnf);
use Test::More qw(no_plan);

use FindBin qw($Bin);
use Cwd 'abs_path';
use lib abs_path("$Bin/../../../../lib");
our $class='Synapse::Request::Factory';
use Synapse::Request;
use Synapse::WebClient;

BEGIN: {
  Options::use(qw(d q v h fuse=i));
    Options::useDefaults(fuse => -1);
    Options::get();
    die Options::usage() if $options{h};
    $ENV{DEBUG} = 1 if $options{d};
}


sub main {
    require_ok($class) or BAIL_OUT("$class has compile issues, quitting");
    my $factory=$class->new(web_client=>new Synapse::WebClient);
    isa_ok($factory, $class);

    my $added_params={
	DeleteEntity=>{entity_id=>'syn371708'},
	FetchEntity=>{entity_id=>'syn4517'},
	SearchEntities=>{search_terms=>[qw(cancer)]},
    };

    while (my ($cmd, $subclass)=each %{$factory->cmd2class}) {
	my $req=$factory->new_request($cmd, $added_params->{$subclass});
	isa_ok($req,
	       join('::',$factory->base_class, $subclass), 
	       $subclass);    
	ok($req->isa('Synapse::Request'), $subclass);
	isa_ok($req->http_request, 'HTTP::Request');
    }
}

main(@ARGV);

