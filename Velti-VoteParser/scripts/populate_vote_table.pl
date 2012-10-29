#!/usr/bin/perl

use strict;
use warnings;
use FindBin qw/$Bin/;
use Getopt::Long;
use Data::Dumper;
use feature qw/say/;

use lib "$Bin/lib";
use Velti::VoteParser;

my ($file);
BEGIN {
  GetOptions(
    "file=s"  => \$file
  ) or die "missing options";
}

my $vp  = Velti::VoteParser->new( file => $file );

$vp->validate;

unless(scalar @{$vp->rows}) {
  say "failed to find any valid rows in file $file";
  exit;
}

