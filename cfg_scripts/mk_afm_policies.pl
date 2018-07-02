#! /usr/bin/perl

use warnings;
use strict;
use Data::Dumper;

my $numPolicy = 1;
my $numRules  = 9999;
#my $numRules  = 20000;
#my $numPolicy = 1;

my $aSrcNet   = 0;
my $bSrcNet   = 0;
my $cSrcNet   = 0;
my $dSrcNet   = 1;
my $srcVlans  = "v111";

my $aDstNet   = 10;
my $bDstNet   = 0;
my $cDstNet   = 0;
my $dDstNet   = 0;
my $dstPorts  = "1024";
my $dstVlans  = "v112";

my $perNetMax = 250;

my $rule;

printf("security firewall policy my_fw_policy {\n  rules {\n");

# security firewall policy my_fw_policy { rules { r001 { action reject ip-protocol tcp destination { addresses { 10.111.0.0/16 { } } ports { 8081 { } } } source { vlans { v114 }}}}}
for ( my $count = 1; $count <= $numPolicy; $count++ ) {
  my $port      = $count + $dstPorts;

  #printf("security firewall policy my_fw_policy%03d {\n  rules {\n", $count);

  for ( $rule = 1; $rule <= $numRules; $rule++ ) {
    if ( $dDstNet > $perNetMax ) { $dDstNet = 1; $cDstNet++; }
    if ( $cDstNet > $perNetMax ) { $cDstNet = 0; $bDstNet++; }
    if ( $bDstNet > $perNetMax ) { $bDstNet = 0; $aDstNet++; }

    #printf("    r%04d { action reject ip-protocol tcp destination { ports { %d { }}}}\n", $rule, $port);
    #printf("    r%05d { action reject ip-protocol tcp destination { addresses { %d.%d.0.0/16 { }} ports { %d { }}} source { vlans { %s }} }\n", $rule, $aDstNet, $bDstNet, $port, $srcVlans);
    printf("    r%05d { action reject ip-protocol tcp destination { addresses { %d.%d.%d.%d/24 { }} ports { %d { }}} }\n", $rule, $aDstNet, $bDstNet, $cDstNet, $dDstNet, $port);
    $port++;
    $cDstNet++;
  }


  #printf("    r%02d { action accept ip-protocol tcp destination { addresses { %d.%d.%d.%d { }} ports { %s { }}}}\n  }\n}\n", $rule, $aDstNet, $bDstNet, $cDstNet, $dDstNet, $dstPorts);

}
  #printf("    r%03d { action accept ip-protocol tcp destination { ports { %s { }}}}\n  }\n}\n", $rule, $dstPorts);
  printf("    r%03d { action accept ip-protocol tcp }\n  }\n}\n", $rule, $dstPorts);
  #printf("    r%03d { action accept ip-protocol tcp destination { addresses { 10.%d.0.0/16 { }} ports { %s { }}} source { vlans { %s }}}\n  }\n}\n", $rule, $bDstNet, $dstPorts, $srcVlans);
