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
  my $file  = "$Bin/samples/sample.txt";
  my @array = (
    "Favourite Foods rice:peas fish:chips pie:mash\n",
    "Nice cars ford:cortina vaxhall:nova mini:metro\n"
  );
  my $obj   = $CLASS->new( file => $file );
  is(scalar @{$obj->file}, scalar @array, "file count");
#is_deeply($obj->file, \@array);
}

done_testing();
