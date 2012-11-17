#!/usr/bin/perl

use strict;
use warnings;
use FindBin qw/$Bin/;
use lib "$Bin/lib";
use feature qw/say/;

use Velti::Schema;
use Data::Dumper;

my $schema  = Velti::Schema->connect("dbi:mysql:velti:localhost:3306","velti","velti123");


my $rs      = $schema->resultset('Vote')->search({});

my $row     = $rs->first;

say "This is conn:". $row->conn;
say "This is status:". $row->status;
say "This is now conn:". $row->conn;

