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


dance;
