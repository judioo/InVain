#!/usr/bin/env perl
use Dancer;
use Velti;
use Dancer::Plugin::DBIC 'schema';


get '/homepage' => sub {
  # we can DBIx::Class to request a distinct list of
  # all our campaigns
  my @campaigns = schema->resultset('Vote')->search(
    {
    },
    {
      distinct  => 1,
      columns   => [qw/campaign/],
    }
  )->all;

  # display in our homepage template
  template homepage => {
    campaigns => \@campaigns
  };
};

get qr{/campaign/([\w_]+)} => sub {
  # use splat in a weak attempt to avoid SQL injection attacks
  my ($campaign)  = splat;
  my $stats       = _get_campaign_stats($campaign);

  template campaign => {
    stats           => $stats,
    campaign_title  => $campaign,
  };
};


sub _get_campaign_stats {
  my $campaign  = shift;
  my %stats;

  # much easier to construct our own SQL in this case
  my $statement = &_get_statement;
  my $dbh       = schema->storage->dbh;

  # key hashref on choice as its the key we are grouping on
  my $rs        = $dbh->selectall_hashref($statement, 'choice', undef, $campaign);

  if(keys %$rs) {
    # much easier to order arrays in template so we create a array ref (rows)
    # ordering our hashes by count desc
    @{$stats{rows}}  = sort{ $b->{count} <=> $a->{count} }map{ $rs->{$_} } keys %$rs;

    for my $type (qw/pre during post/) {
      # while we are here we might as well get the campaign stats
      # for pre, during and post votes
      map{ 
        ($rs->{$_}{validity} eq $type) && 
        ($stats{$type} += $rs->{$_}{count}) &&
        ($stats{total} += $rs->{$_}{count})
      } keys %$rs;
    }
  }

  return \%stats;
}

sub _get_statement {
  # SQL below will group a given campaign by choice and validity
  # and provide a tally count of validity types ( per choice )
  # ... did that make sense?
  return <<END_OF_SQL;
  SELECT 
    campaign, validity, choice, count(validity) AS count 
  FROM 
    vote 
  WHERE 
    campaign = ?
  GROUP BY 
    campaign, choice, validity 
  ORDER BY 
    count DESC

END_OF_SQL

}


dance;
