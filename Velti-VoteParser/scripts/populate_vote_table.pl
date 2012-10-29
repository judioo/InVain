#!/usr/bin/perl

use strict;
use warnings;
use FindBin qw/$Bin/;
use Getopt::Long;
use Data::Dumper;
use feature qw/say/;
use DateTime;

use lib "$Bin/lib";
use Velti::VoteParser;

my ($file);
BEGIN {
  GetOptions(
    "file=s"  => \$file
  ) or die "missing options";
}

sub format_keys {
  # lowercase keys
  my $row = shift;
  map{ 
    my $val = $row->{$_};
    delete $row->{$_};
    $row->{lc($_)}  = $val;
  } keys %$row;

  return $row;
}
my $vp  = Velti::VoteParser->new( file => $file );

$vp->validate;

unless(scalar @{$vp->rows}) {
  say "failed to find any valid rows in file $file";
  exit;
}


# insert
say "Starting Inserts";
for my $row (@{$vp->rows}) {
  $row  = format_keys($row);
  # convert epoch to datetime
  $row->{vote}  = DateTime->from_epoch( epoch => $row->{vote} );
}

say "Done!";
