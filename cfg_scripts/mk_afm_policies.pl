#! /usr/bin/perl

use warnings;
use strict;
use Data::Dumper;

my $numPolicy = 1;
my $numRules  = 250;
#my $numRules  = 20000;
#my $numPolicy = 1;

my $aSrcNet   = 0;
my $bSrcNet   = 0;
my $cSrcNet   = 0;
my $dSrcNet   = 1;
my $srcVlans  = "v107";

my $aDstNet   = 10;
my $bDstNet   = 108;
my $cDstNet   = 0;
my $dDstNet   = 0;
my $dstPorts  = "80";
my $dstVlans  = "v108";

my $perNetMax = 1000;

my $rule;

printf("security firewall policy my_fw_policy {\n  rules {\n");

# security firewall policy my_fw_policy { rules { r001 { action reject ip-protocol tcp destination { addresses { 10.111.0.0/16 { } } port { 8081 { } } } source { vlans { v114 }}}}}
for ( my $count = 1; $count <= $numPolicy; $count++ ) {
  my $port      = $count + $dstPorts;

  #printf("security firewall policy my_fw_policy%03d {\n  rules {\n", $count);

  for ( $rule = 1; $rule <= $numRules; $rule++ ) {
    #printf("    r%03d { action reject ip-protocol tcp destination { port { %d { }}}}\n", $rule, $port);
    printf("    r%03d { action reject ip-protocol tcp destination { addresses { 10.%d.0.0/16 { }} ports { %d { }}} source { vlans { %s }} }\n", $rule, $bDstNet, $port, $srcVlans);
    $port++;
  }

  if ( $dDstNet > $perNetMax ) {
    $dDstNet = 1;
    $cDstNet++;
  }

  #printf("    r%02d { action accept ip-protocol tcp destination { addresses { %d.%d.%d.%d { }} port { %s { }}}}\n  }\n}\n", $rule, $aDstNet, $bDstNet, $cDstNet, $dDstNet, $dstPorts);

  #$dDstNet++;
}
  #printf("    r%03d { action accept ip-protocol tcp destination { port { %s { }}}}\n  }\n}\n", $rule, $dstPorts);
  printf("    r%03d { action accept ip-protocol tcp destination { addresses { 10.%d.0.0/16 { }} ports { %s { }}} source { vlans { %s }}}\n  }\n}\n", $rule, $bDstNet, $dstPorts, $srcVlans);
