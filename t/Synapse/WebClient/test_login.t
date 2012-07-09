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
    my $sr=$factory->new_request('login') or 
	die "unknown command 'login'\n";
    ok ($sr->isa('Synapse::Request'), ref $sr);
    my $session_token=$swc->post($sr);
    like($session_token, qr/^\w{24}$/, $session_token); # session token looks ok
    ok(-r $swc->session_token_file, 'got session token file'); # session file exists

    ok(open(SESSION, $swc->session_token_file));    
    my $st2=<SESSION>;
    chomp $st2;
    close SESSION;
    cmp_ok($session_token, 'eq', $st2, $st2); # stored session matches return from hook:
}

main(@ARGV);

