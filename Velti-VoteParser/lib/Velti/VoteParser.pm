package Velti::VoteParser;
use Moose;
use Moose::Util::TypeConstraints;
use File::Slurp ();
use Carp;

  subtype 'VP::File::Slurp'
    => as 'ArrayRef[Str]';

  coerce 'VP::File::Slurp'
    => from 'Str'
    => via { [File::Slurp::read_file( $_[0], chomp => 1 )] };

  has 'file'  => (is => 'ro', isa => 'VP::File::Slurp', coerce => 1);

our %rowOrder = (
  0   => 'VOTE',
  2   => 'Campaign',
  4   => 'Validity',
  6   => 'Choice',
  8   => 'CONN',
  10  => 'MSISDN',
  12  => 'GUID',
  14  => 'Shortcode'
);

sub _decode_row {
  my $self  = shift;
  my $row   = shift;
  my @array = map { split ":", $_ } (split " ", $row);

  return \@array;
}

sub _validate_row {
  my $self  = shift;
  my $array = shift;

  for my $key (keys %rowOrder) {
    unless($array->[$key] eq $rowOrder{$key}) {
      carp $rowOrder{$key}." failed for row:\n@$array";
      return 0
    }
  }
  return 1;
}
1;
