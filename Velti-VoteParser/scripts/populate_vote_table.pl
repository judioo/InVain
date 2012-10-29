#!/usr/bin/perl

use strict;
use warnings;
use FindBin qw/$Bin/;
use Getopt::Long;
use Data::Dumper;
use feature qw/say/;
use DBI;
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

sub insert_row {
  my $dbh   = shift;
  my $row   = shift;
  my @cols  = qw/vote campaign validity choice conn msisdn guid shortcode/;
  
  my $statement = "INSERT INTO vote (".(join ',', @cols).") VALUES (?,?,?,?,?,?,?,?)";
  $dbh->do($statement,undef,(map{ $row->{$_} } @cols))
    or die "could not INSERT $DBI::errstr\n";
}



# setup
my $ddbh = DBI->connect("dbi:mysql:velti:localhost:3306","velti","velti123")
            or die "cannot connect to DB: $DBI::errstr";

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

  insert_row($ddbh, $row);
}

say "Done!";
