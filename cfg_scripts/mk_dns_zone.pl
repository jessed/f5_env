#! /usr/bin/perl

use warnings;
use strict;


my $count   = 2000;
my $aNet    = 20;
my $bNet    = 1;
my $cNet    = 0;
my $dNet    = 1;

my @records;

for ( my $c = 1; $c <= $count; $c++ ) {

  if ( $dNet > 250 ) { $dNet = 1; $cNet++; }

  my $host  = sprintf("host%04d\t\tA\t%d.%d.%d.%d\n", $c, $aNet, $bNet, $cNet, $dNet);

  push(@records, $host);
  $dNet++;
}

print @records;

