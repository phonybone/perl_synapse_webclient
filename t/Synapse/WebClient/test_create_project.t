#!/usr/bin/env perl 
#-*-perl-*-
use strict;
use warnings;
use Carp;
use Data::Dumper;
use Options;

use Test::More qw(no_plan);

use FindBin qw($Bin);
use Cwd 'abs_path';
use lib abs_path("$Bin/../../../lib");
our $class='Synapse::WebClient';

use Synapse::Request::Factory;

BEGIN: {
  Options::use(qw(d q v h fuse=i));
    Options::useDefaults(fuse => -1);
    Options::get();
    die Options::usage() if $options{h};
    $ENV{DEBUG} = 1 if $options{d};
}


sub main {
    require_ok($class) or BAIL_OUT("$class has compile issues, quitting");
    my $swc=$class->new;
    my $factory=Synapse::Request::Factory->new(web_client=>$swc);
    my $sr=$factory->new_request('create_project') or 
	die "unknown command 'create_project'\n";
    ok ($sr->isa('Synapse::Request'), ref $sr);
    my $project=$swc->post($sr);
    warn "project is ", Dumper($project);

}

main(@ARGV);

