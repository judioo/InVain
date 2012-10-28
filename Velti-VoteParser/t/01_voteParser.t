#!/usr/bin/perl

use Test::Most tests => 1;
use FindBin;

use lib "$FindBin::Bin/../lib";
use lib "$FindBin::Bin/lib";

our $CLASS  = "Velti::VoteParser";
use_ok($CLASS);
