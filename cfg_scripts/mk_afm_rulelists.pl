#! /usr/bin/perl

use warnings;
use strict;
use Data::Dumper;

my $numPolicy = 1;
my $numRules  = 10000;

my $aSrcNet   = 0;
my $bSrcNet   = 0;
my $cSrcNet   = 0;
my $dSrcNet   = 1;
my $srcVlans  = "v107";

my $aDstNet   = 121;
my $bDstNet   = 0;
my $cDstNet   = 0;
my $dDstNet   = 0;
my $dstPorts  = "8080";
my $dstVlans  = "v108";

my $perNetMax = 250;

my $rule;

## address-list sample
# security firewall address-list al_00001 { addresses { 155.60.208.132 { } } description "IRESS Market Technology" }

## port-list sample
# security firewall port-list pl_00001 { ports { 8081 }}

## rule-list sample
# security fierewall rule-list rl_00001 { rules { r01 { action drop ip-protocol tcp destination { address-lists { al_00001 } port-lists { pl_00001 } } source { addresses { 0.0.0.0/0 }}}}}

for ( my $count = 1; $count <= $numRules; $count++ ) {
  my $pl_name   = sprintf("pl_%05d", $count);
  my $al_name   = sprintf("al_%05d", $count);
  my $rl_name   = sprintf("rl_%05d", $count);

  # define port number for use in port-list
  my $port      = $count + $dstPorts;

  if ($dDstNet > $perNetMax) { $dDstNet = 1; $cDstNet++; }
  if ($cDstNet > $perNetMax) { $dDstNet = 1; $cDstNet = 1; $bDstNet++; }

  # define ip address for use in address-list
  my $addr      = sprintf("%d.%d.%d.%d", $aDstNet, $bDstNet, $cDstNet, $dDstNet);

  printf("security firewall port-list %s { ports { %d }}\n", $pl_name, $port);
  printf("security firewall address-list %s { addresses { %s }}\n", $al_name, $addr);

  printf("security firewall rule-list %s { rules { r01 { action drop ip-protocol tcp destination { address-lists { %s } port-lists { %s }} source { addresses { 0.0.0.0/0 }}}}}\n\n", $rl_name, $al_name, $pl_name);


  $dDstNet++;
}
