#! /usr//bin/perl

use strict;
use warnings;

my $domain      = "f5test.net";
my $newRecords  = 5000;
my $firstRR     = 1;

my $rrPrefix    = "host";
my $recordType  = "A";

my $aNet        = 10;
my $bNet        = 10;
my $cNet        = 1;
my $dNet        = 1;

my $zoneFile    = "$domain.zone";

my ($addr, $host, @records);


##
## Begin Main

# Open the zonefile and write the bind domain section
open(ZONE, ">", $zoneFile);
&zone_header($domain, *ZONE);

# Generate the hostnames and addresses for each record
for ( my $rr = $firstRR; $rr <= $newRecords; $rr++ ) {

  # If $dNet exceeds 254 reset to 1 and increment $cNet
  if ( $dNet > 254 ) { $dNet = 1; $cNet++; }

  # If $cNet exceeds 254 reset to 1 and increment $bNet
  if ( $cNet > 254 ) { $cNet = 1; $bNet++; }

  $addr   = "$aNet.$bNet.$cNet.$dNet";
  #$host   = sprintf("%s%06d", $rrPrefix, $rr);
  $host   = sprintf("%s%06d", $rrPrefix, $rr);

  # Add host and address to list
  push(@records, {name => $host, addr => $addr, type => $recordType});

  # increment $dNet for next record entry
  $dNet++;
}

foreach my $n (@records) {
  printf ZONE "%s                    %s        %s\n", $n->{name}, $n->{type}, $n->{addr};
}

close(ZONE);


##
## Begin Subs

sub zone_header() {
  my $domain  = shift;
  my $file    = shift;

  print $file <<END;
\$ORIGIN .
\$TTL 10  ; 10 seconds
$domain    IN SOA  ns1.$domain. root.$domain. (
        2015101301 ; serial
        21600      ; refresh ( 6 hours)
         3600      ; retry   (46 minutes 40 seconds)
        64800      ; expire  (18 hours)
           10      ; minimum (10 seconds)
        )
      NS  ns1.$domain.
\$ORIGIN $domain.
ns1                           A  10.111.255.253

END
}
