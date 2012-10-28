#!/usr/bin/perl

use Test::Most;
use FindBin qw/$Bin $Script/;

use lib "$Bin/lib";

our $CLASS  = "Velti::VoteParser";
use_ok($CLASS);


# new 
{
  my $obj = $CLASS->new();
  isa_ok($obj, $CLASS);
}

# new with file. Corce file into array of rows
{
  my $file  = "$Bin/samples/vote.txt";
  my @array = (
    "Favourite Foods rice:peas fish:chips pie:mash",
    "Nice cars ford:cortina vaxhall:nova mini:metro"
  );
  my $obj   = $CLASS->new( file => $file );
  is_deeply($obj->file, \@array);
}

done_testing();
