#! /usr/bin/perl

use warnings;
use strict;

use Getopt::Std;
use Data::Dumper;
use Switch;
#TODO: implement JSON output and use iControl REST to automatically update
#      the target LTM

###
### NOTE: If the pool member or vip addresses are being cut off updated the 
###       sprintf() statement for each. You can find them by searching for 
###       'poolCfg' and 'vipCfg' respectively.
###



our (%opts, $VIPCOUNT);
getopts('c:hD', \%opts);

if (!$opts{'c'}) {
  warn("Must provide the number of objects to create (-c)");
  &usage(1);
}

# print usage and exit
&usage(0) if $opts{'h'};

# enable debug output if specificied on cli
my $DEBUG   = $opts{'D'} || 0;


# These options affect the number and configuration of the objects being created.
# Eventually most of these will be controllable through cli options
my $cfg  = {
  'mkTotal'         =>  ($opts{'c'} || 10), # The total number of objects to create
  'uniqueVipAddr'   =>  1,          # 0: use same address, increment ports. 1: unique adresses, same port
  'printVips'       =>  1,          # 
  'vipPrefix'       =>  'vs',       # 
  'vipPostfix'      =>  "",         # 
  'vipStart'        =>  1,          # 
  'vipPort'         =>  443,        # 
  'vip_aNet'        =>  10,         # 
  'vip_bNet'        =>  101,        # 
  'vip_cNet'        =>  11,         # 
  'vip_dNet'        =>  1,          # 
  'poolPrefix'      =>  'p',        # 
  'poolStart'       =>  1,          # 
  'poolMaxUsage'    =>  1,          # 
  'poolMbrCount'    =>  4,          # 
  'uniquePoolMbrs'  =>  2,          # 0: reuse original nodes, 1: never reuse nodes, 2: reuse nodes $nodeMaxUsage times
  'nodeMaxUsage'    =>  10,         # 
  'node_aNet'       =>  10,         # 
  'node_bNet'       =>  102,        # 
  'node_cNet'       =>  110,        # 
  'node_dNet'       =>  1,          # 
  'nodePort'        =>  443,        # 
};

##
## No user-configurable variables below this point
##

# Contains the generated configuration for the current loop
my $cur = {
  'vipNum'          => $cfg->{'vipStart'},
  'vipName'         => "",
  'poolNum'         => $cfg->{'poolStart'},
  'poolName'        => "",
  'nodes'           => [],
  'vipCount'        => 0,
  'poolCount'       => 0,
  'nodeCount'       => 0,
};

# These are used to track the various objects that have been created
my $state  = {
  'uniqueNodeCount' =>  0,
  'lastPoolName'    =>  "null",
  'reusePool'       =>  0,
  'newPool'         =>  0,
  'newNodes'        =>  0,
  'reuseNodes'      =>  0,
  'nodeUseCount'    =>  0,
};

# Instantiate now to keep the code cleaner later
my @vips;
my @pools;


###
### Begin Main
###

# Define vip name and address:port
# This for loop controls the number of objects created in general,
# not just vips
for ( my $vipNum = 1; $vipNum <= $cfg->{'mkTotal'}; $vipNum++ ) {
  $cur->{'vipName'} = sprintf("%s%05d%s", $cfg->{'vipPrefix'}, $cur->{'vipNum'}, $cfg->{'vipPostfix'});
  $cur->{'vipAddr'} = sprintf("%d.%d.%d.%d:%d", $cfg->{'vip_aNet'},
                                              $cfg->{'vip_bNet'},
                                              $cfg->{'vip_cNet'},
                                              $cfg->{'vip_dNet'},
                                              $cfg->{'vipPort'});

  # Don't use more than 250 address per /24
  if ( $cfg->{'uniqueVipAddr'} && $cfg->{'vip_dNet'} >= 250 ) {
    $cfg->{'vip_cNet'}++;
    $cfg->{'vip_dNet'} = 1;
  }
  else {
    $cfg->{'vip_dNet'}++;
  }

  $cur->{'vipNum'}++;
  $cur->{'vipCount'}++;   # $cur->{'vipCount'} has no use at the moment
  
  ### Vip name and address are now defined


  # Should the pool be reused or a new one created
  if ( ! $state->{'reusePool'} ) {
    $cur->{'poolName'} = sprintf("%s%05d", $cfg->{'poolPrefix'}, $cur->{'poolNum'});
    $cur->{'poolNum'}++;
    $state->{'newPool'} = 1;

    # Increment the pool count
    $cur->{'poolCount'}++;
  }
  else {
    $state->{'newPool'} = 0;
  }

  # track how many times we've used this pool. 
  if ( $state->{$cur->{'poolName'}}) { $state->{$cur->{'poolName'}}++; }
  else {                               $state->{$cur->{'poolName'}} = 1; }


  ### Pool name is now defined ###


  # Define pool members if we've created a new pool
  if (!$state->{'reuseNodes'}) {
    #$DEBUG && printf("Creating new nodes: (reuseNodes: %d, nodeUseCount: %d)\n", $state->{'reuseNodes'}, $state->{'nodeUseCount'});
    for ( my $n = 0; $n < $cfg->{'poolMbrCount'}; $n++ ) {
      push(@{$cur->{'nodes'}}, sprintf("%d.%d.%d.%d:%d", $cfg->{'node_aNet'},
                                                         $cfg->{'node_bNet'},
                                                         $cfg->{'node_cNet'},
                                                         $cfg->{'node_dNet'},
                                                         $cfg->{'nodePort'}));

      # Move to the next /24 network, if necessary
      if ( $cfg->{'node_dNet'} >= 254 ) { $cfg->{'node_dNet'} = 1; $cfg->{'node_cNet'}++; }
      else {                              $cfg->{'node_dNet'}++; }

      $cur->{'nodeCount'}++;
    }
    $state->{'nodeUseCount'}++;
  }
  else {
    $state->{'nodeUseCount'}++;
  }

  ### Node list has now been defined ###
  

  ##
  ## Format and print the ltm config 
  ##

  # If this is a new pool, create the config
  if ( $state->{'newPool'} ) {
    my ($poolMbrs, $poolCfg);

    foreach my $n (@{$cur->{'nodes'}}) { $poolMbrs .= sprintf("%-20s", $n); }

    $poolCfg = sprintf("ltm pool %s { members { %s }}", $cur->{'poolName'}, $poolMbrs);
    push(@pools, $poolCfg);

    undef $poolMbrs;
    undef $poolCfg;
  }


  my $vipCfgOpts = "profiles { fastL4 }";
  my $vipCfg = sprintf("ltm virtual %s { destination %-19s pool %s %s }",
                    $cur->{'vipName'},
                    $cur->{'vipAddr'},
                    $cur->{'poolName'}, $vipCfgOpts);

  push(@vips, $vipCfg);


  ##
  ## Update state and perform end-of-loop cleanup
  ##

  # Update lastPoolName
  $state->{'lastPoolName'} = $cur->{'poolName'};

  # disable pool reuse if the pool has been used $cfg->{'poolMaxUsage'} times
  if ( $state->{$cur->{'poolName'}} < $cfg->{'poolMaxUsage'} ) {
    $state->{'reusePool'} = 1;
    $state->{'newPool'}   = 0;
  }
  else {
    $state->{'reusePool'} = 0;
  }


  # Update node list based on reuse settings
  #   0: always reuse pool members
  #   1: never reuse pool members
  #   2: reuse pool members $cfg->{'poolMbrReuse'} times
  switch($cfg->{'uniquePoolMbrs'}) {
    case 0  { }
    case 1  {
      undef @{$cur->{'nodes'}};
    }
    case 2  {
      if ( $state->{'nodeUseCount'} >= $cfg->{'nodeMaxUsage'} ) {
        undef @{$cur->{'nodes'}};
        $state->{'nodeUseCount'} = 0;
        $state->{'reuseNodes'}   = 0;
      }
      else {
        $state->{'reuseNodes'} = 1;
      }
    }
  }
}



for my $p (@pools) { print "$p\n"; }
print "\n";
for my $v (@vips)  { print "$v\n"; }




sub usage() {
  my $status = shift;
  
  print <<END;
  USAGE: $0 -c <count> [-h]

  -c      Number of objects to create (default: 10)
  -h      Print usage and exit

END

  exit($status);
}
