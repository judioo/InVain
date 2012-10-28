#!/usr/bin/perl

use Test::Most tests => 1;
use FindBin;

use lib "$FindBin::Bin/../lib";

use_ok("Velti::VoteParser");
