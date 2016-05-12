#! /usr/bin/perl

use warnings;
use strict;
use Data::Dumper;

my $numPolicy = 500;
my $numRules  = 40;
#my $numRules  = 20000;
#my $numPolicy = 1;

my $aSrcNet  = 10;
my $bSrcNet  = 102;
my $cSrcNet  = 100;
my $dSrcNet  = 0;

my $aDstNet   = 10;
my $bDstNet   = 101;
my $cDstNet   = 11;
my $dDstNet   = 1;
my $dstPorts  = "80 443";

my $perNetMax = 100;

my $rule;

for ( my $count = 1; $count <= $numPolicy; $count++ ) {
  my $port      = $count + 1024;

  printf("security firewall policy afm_policy%03d {\n  rules {\n", $count);

  for ( $rule = 1; $rule < $numRules; $rule++ ) {
    printf("    r%02d { action drop ip-protocol tcp log yes destination { ports { %d { }}}}\n", $rule, $port);
    $port++;
  }

  if ( $dDstNet > $perNetMax ) {
    $dDstNet = 1;
    $cDstNet++;
  }

  #printf("    r%02d { action accept ip-protocol tcp destination { addresses { %d.%d.%d.%d { }} ports { %s { }}}}\n  }\n}\n", $rule, $aDstNet, $bDstNet, $cDstNet, $dDstNet, $dstPorts);
  printf("    r%02d { action accept ip-protocol tcp log yes destination { ports { %s { }}}}\n  }\n}\n", $rule, $dstPorts);

  $dDstNet++;
}
