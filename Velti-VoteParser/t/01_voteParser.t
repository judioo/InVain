#!/usr/bin/perl

use Test::Most tests => 2;
use FindBin;

use lib "$FindBin::Bin/../lib";
use lib "$FindBin::Bin/lib";

our $CLASS  = "Velti::VoteParser";
use_ok($CLASS);


# new 
{
  my $obj = $CLASS->new();
  isa_ok($obj, $CLASS);
}

# new with file
{
  my $file  = "$FindBin::Script/samples/vote.txt";
  my $obj   = $CLASS->new( file => $file );
  cmp_ok($obj->file, 'eq', $file);
}
