package Velti::VoteParser;
use Moose;
use Moose::Util::TypeConstraints;
use File::Slurp ();

  subtype 'VP::File::Slurp'
    => as 'ArrayRef[Str]';

  coerce 'VP::File::Slurp'
    => from 'Str'
    => via { [File::Slurp::read_file( $_[0], chomp => 1 )] };

  has 'file'  => (is => 'ro', isa => 'VP::File::Slurp', coerce => 1);
1;
