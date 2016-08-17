#! /usr/bin/perl

use strict;
use warnings;

use Getopt::Std;
use Data::Dumper;

our (%opts, $WIPCOUNT);
getopts('c:d:hD', \%opts);

# Print usage and exit
&usage(0) if $opts{'h'};

# Ensure required arguments are supplied 
if (!$opts{'c'}) {
  warn("Must specify the number of objects to create and which data-center to create them for");
  &usage(1);
}

my $DEBUG = $opts{'D'} || 0;


my $cfg = {
  'mkTotal'       => ($opts{'c'} || 10), # make 10 objects by default
  'wipStart'      => 1,
  'printWips'     => 1,
  'printPools'    => 1,
  'printSrvs'     => 1,
  'printVS'       => 1,
  'wipPrefix'     => 'wip',
  'poolPrefix'    => 'pool',
  'poolMbrCount'  => '2',
  'sPrefix'       => 'srv',
  'vsPrefix'      => 'vs',
  'srvAnet'       => 10,
  'srvBnet'       => 101,
  'srvCnet'       => 101,
  'srvDnet'       => 1,
  'vsAnet'        => 10,
  'vsBnet'        => 101,
  'vsCnet'        => 201,
  'vsDnet'        => 1,
  'vsPort'        => 80,
};

my $datacenters = {
  'DC01'  => 101,
  'DC02'  => 102,
};


my $cur = {
  'wipNum'        => $cfg->{'wipStart'},
  'wipName'       => "",
  'poolNum'       => $cfg->{'poolStart'},
  'poolName'      => "",
  'srvNum'        => $cfg->{'srvStart'},
  'srvName'       => "",
  'vsNum'         => 1,
  'vsName'        => "",
  'srvAnet'       => $cfg->{'srvAnet'},
  'srvBnet'       => $cfg->{'srvBnet'},
  'srvCnet'       => $cfg->{'srvCnet'},
  'srvDnet'       => $cfg->{'srvDnet'},
  'vsAnet'        => $cfg->{'vsAnet'},
  'vsBnet'        => $cfg->{'vsBnet'},
  'vsCnet'        => $cfg->{'vsCnet'},
  'vsDnet'        => $cfg->{'vsDnet'},
};

# Instantiate now for code cleanliness
my @servers;
my @pools;
my @poolMbrs;
my @wips;

###
### Begin main
###

# 1. Create server (one per-DC)
# 2. Create virtual-servers (one per-server)
# 3. Create pools w/virtual-servers
# 4. Create WIP using pool

for ( my $wipCount = $cfg->{'wipStart'}; $wipCount < ($cfg->{'wipStart'} + $cfg->{'mkTotal'}); $wipCount++ ) {

  # Define servers and virtual-servers
  foreach my $dc (keys($datacenters)) {
    my $srvAnet = $cur->{'srvAnet'};
    my $srvBnet = $datacenters->{$dc};
    my $srvCnet = $cur->{'srvCnet'};
    my $srvDnet = $cur->{'srvDnet'};

    # Update address if we have reached the end of the allowed address range
    if ( $cur->{'srvDnet'} > 250 ) { $cur->{'srvCnet'}++; $cur->{'srvDnet'} = 1; }

    my $srvName = lc(sprintf("%s_%s_%05d", $cfg->{'sPrefix'}, $dc, $wipCount));
    my $srvIp   = sprintf("%d.%d.%d.%d", $srvAnet, $srvBnet, $srvCnet, $srvDnet);

    my $vsAnet = $cur->{'vsAnet'};
    my $vsBnet = $datacenters->{$dc};
    my $vsCnet = $cur->{'vsCnet'};
    my $vsDnet = $cur->{'vsDnet'};
    my $vsPort = $cfg->{'vsPort'};
    if ( $cur->{'vsDnet'} > 250 )  { $cur->{'vsCnet'}++;  $cur->{'vsDnet'}  = 1; }

    # Generate virtual-server name, address, and config definition
    my $vsName  = lc(sprintf("%s_%s_%05d", $cfg->{'vsPrefix'}, $dc, $wipCount));
    my $vsIp    = sprintf("%d.%d.%d.%d", $vsAnet, $vsBnet, $vsCnet, $vsDnet);
    my $vsDef   = sprintf("%s { destination %s:%d }", $vsName, $vsIp, $vsPort);


    my $srvDef  = sprintf("gtm server %s { addresses { %s { device-name %s } } datacenter %s product generic-host virtual-servers { %s } }", $srvName, $srvIp, $srvName, $dc, $vsDef);

    push(@servers, $srvDef);
    push(@poolMbrs, "$srvName:$vsName");

  }
  $cur->{'srvDnet'}++;
  $cur->{'vsDnet'}++;

  #
  # Create pool definition
  #
  my $poolName  = sprintf("p%05d", $wipCount);
  my $mbrList   = join(' ', @poolMbrs);

  my $poolDef = "gtm pool $poolName { verify-member-availability disabled members add { $mbrList } }";

  push(@pools, $poolDef);
  @poolMbrs = ();

  #
  # Create Wide-IP definition
  #
  my $wipName = sprintf("wip%05d.f5net.net", $wipCount);
  my $wipDef = "gtm wideip $wipName { pools { $poolName } }";

  push(@wips, $wipDef);

}

print "\n#Servers\n";
foreach my $s (@servers) {
  print "$s\n";
}

print "\n#Pools\n";
foreach my $p (@pools) {
  print "$p\n";
}

print "\n#Wide-IPs\n";
foreach my $w (@wips) {
  print "$w\n";
}
