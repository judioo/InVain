package Velti::VoteParser;

use strict;
use warnings;

sub new {
  my $class = shift;
  my %args  = @_;
  bless \%args, ref($class) || $class;
}

sub file {
  my $self  = shift;
  return (exists $self->{file})
    ? $self->{file}
    : undef;
}

1;
