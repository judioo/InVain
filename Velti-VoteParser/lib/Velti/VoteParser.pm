package Velti::VoteParser;

use strict;
use warnings;

sub new {
  my $class = shift;
  my %args  = @_;
  return \%args, ref($class) || $class;
}

1;
