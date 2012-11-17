package Velti::Schema::Result::Vote;

use strict;
use warnings;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime PK::Auto/);
__PACKAGE__->table('vote');
__PACKAGE__->add_columns(qw/id vote campaign validity choice conn msisdn guid shortcode/);
__PACKAGE__->set_primary_key('id');

sub status {
  my $self  = shift;
  $self->conn(lc $self->conn);
}

1;
