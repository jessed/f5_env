#! /usr/bin/perl

use warnings;
use strict;


my $zone		= "amazon.com";

my $count   = 5000;

my $aNet    = 3;
my $bNet    = 10;
my $cNet    = 1;
my $dNet    = 1;

my @records;


&print_headers($zone);

for ( my $c = 1; $c <= $count; $c++ ) {

  if ( $dNet > 250 ) { $dNet = 1; $cNet++; }
  if ( $cNet > 250 ) { $dNet = 1; $cNet = 1; $bNet++ }

  my $host  = sprintf("host%05d\t\tA\t%d.%d.%d.%d\n", $c, $aNet, $bNet, $cNet, $dNet);

  push(@records, $host);
  $dNet++;
}

print @records;



sub print_headers() {
	my $zone		= shift;

	my $ZONE_HDR = "\$ORIGIN .
\$TTL 10	; 10 seconds
$zone		IN SOA	ns1.$zone. root.$zone. (
				2018032301 ; serial
				21600      ; refresh ( 6 hours)
				 3600      ; retry   (46 minutes 40 seconds)
				64800      ; expire  (18 hours)
				   10      ; minimum (10 seconds)
				)
			NS	ns1.$zone.
ns1		A	10.111.101.10
\$ORIGIN $zone.
";

	print "$ZONE_HDR\n\n";
}
