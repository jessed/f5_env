#! /usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my $vs_aNet     = 10;
my $vs_bNet     = 101;
my $vs_cNet     = 11;
my $vs_dNet     = 1;

my $vs_port     = 443;

my $first       = 1;
my $last        = 300;
my $perNetMax   = 100;

my $vsSuffix    = "https";
my $poolSuffix  = "https";

# var: asm policy name, asm template name
my $asmTemplate = "asm policy %s { active encoding utf-8 policy-template %s }";
my $asmTmplName = "asm_ag_template";

# var: ltm policy name, asm policy name
my $ltmTemplate = "ltm policy %s { controls { asm } requires { http } rules { default { actions { 0 { asm enable policy %s }} ordinal 1 }} strategy first-match }";

# var: pool name
my $poolMembers = "10.102.100.1:443 10.102.100.2:443 10.102.100.3:443 10.102.100.4:443 10.102.100.5:443 10.102.100.6:443 10.102.100.7:443 10.102.100.8:443";
my $poolTemplate = "ltm pool %s { members { $poolMembers } }";

# var: vip name, vip address, pool name, ltm policy name, afm policy name
#my $vipProfiles = "tcp xff_http websecurity";
my $vipProfiles = "clientssl { context clientside } serverssl { context serverside} tcp xff_http websecurity";
my $vipTemplate = "ltm virtual %s { destination %s pool %s policies {%s} profiles {%s} fw-enforced-policy %s }";

my ($ltmPolicyName, $afmPolicyName, $asmPolicyName, $poolName, $vipName);
my ($afmPolicyNum);


for ( my $num = $first; $num <= $last; $num++) {
  $afmPolicyNum   = $num + 200;
  #$asmPolicyName  = sprintf("asm_policy%03d", $num); 
  $afmPolicyName  = sprintf("afm_policy%03d", $afmPolicyNum); 
  #$ltmPolicyName  = sprintf("ltm_policy%03d", $num); 
  $ltmPolicyName  = "ltm_policy001";

  $poolName       = sprintf("p%03d-%s", $num, $poolSuffix);
  $vipName        = sprintf("vs%03d-%s", $num, $vsSuffix);

  if ( $vs_dNet > $perNetMax) {
    $vs_dNet = 1;
    $vs_cNet++;
  }

  my $vipAddr   = sprintf("%d.%d.%d.%d:%d", $vs_aNet, $vs_bNet, $vs_cNet, $vs_dNet, $vs_port);

  printf("$poolTemplate\n", $poolName);
  printf("$vipTemplate\n\n", $vipName, $vipAddr, $poolName, $ltmPolicyName, $vipProfiles, $afmPolicyName);

  $vs_dNet++;
}
