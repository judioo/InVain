#!/usr/bin/perl

use Test::Most tests => 2;
use FindBin;

use lib "$FindBin::Bin/../lib";
use lib "$FindBin::Bin/lib";

our $CLASS  = "Velti::VoteParser";
use_ok($CLASS);


# new 
{
$DB::single=1;
  my $obj = $CLASS->new();
  isa_ok($obj, $CLASS);
}
