#!/usr/bin/perl

use Test::Most;
use FindBin qw/$Bin $Script/;

use lib "$Bin/lib";

our $CLASS  = "Velti::VoteParser";
use_ok($CLASS);

our $base_dir = ( -d "$Bin/samples" )
    ? "$Bin/samples/"
    : "$Bin/../samples/";


# new 
{
  my $obj = $CLASS->new();
  isa_ok($obj, $CLASS);
}

# new with file. Corce file into array of rows
{
  my $file  = $base_dir."sample.txt";
  my @array = (
    "Favourite Foods rice:peas fish:chips pie:mash\n",
    "Nice cars ford:cortina vaxhall:nova mini:metro\n"
  );
  my $obj   = $CLASS->new( file => $file );
  is(scalar @{$obj->file}, scalar @array, "file count");
#is_deeply($obj->file, \@array);
}


# task states that the parser needs to 
# a) ensure string is well formed (all required fields are present)
# wekk formed string gives
# VOTE 1168041980 Campaign:ssss_uk_01B Validity:during Choice:Tupele CONN:MIG00VU MSISDN:00777778429999 GUID:A12F2CF1-FDD4-46D4-A582-AD58BAA05E19 Shortcode:63334
# 
# decode string into key -> value pairs then validate

# decode
{
  my $obj       = $CLASS->new();
  my $row       = "VOTE 1168041980 Campaign:ssss_uk_01B Validity:during ".
                  "Choice:Tupele CONN:MIG00VU MSISDN:00777778429999 ".
                  "GUID:A12F2CF1-FDD4-46D4-A582-AD58BAA05E19 Shortcode:63334";

  my @expected  = qw/VOTE 1168041980 Campaign ssss_uk_01B Validity during
                    Choice Tupele CONN MIG00VU MSISDN 00777778429999 
                    GUID A12F2CF1-FDD4-46D4-A582-AD58BAA05E19 Shortcode 63334/;
    
  my $res       = $obj->_decode_row($row);
  is_deeply($res, \@expected, "decode string");
}

# validate
# pass array (will be from decoder) into validator and check we have all the fields required.
# print failing arrays to screen.
# return 1 if array is valid
{
  my $obj           = $CLASS->new();
  my @valid_array   = qw/VOTE 1168041980 Campaign ssss_uk_01B Validity during
                    Choice Tupele CONN MIG00VU MSISDN 00777778429999 
                    GUID A12F2CF1-FDD4-46D4-A582-AD58BAA05E19 Shortcode 63334/;
  is($obj->_validate_row(\@valid_array),1,"vaidate row");

  my @invalid_array = qw/VOTE 1168041980 Campaign ssss_uk_01B Valid during
                    Choice Tupele CONN MIG00VU MSISDN 00777778429999 
                    GUID A12F2CF1-FDD4-46D4-A582-AD58BAA05E19 Shortcode 63334/;

  is($obj->_validate_row(\@invalid_array),0,"invaidate row");

}


done_testing();
