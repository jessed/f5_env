#! /bin/bash

if [[ $1 ]]; then VIPS=$1; else VIPS=10; fi

version=11          # LTM version
uniqueVipAddr=1     # 0 = Increment vip port, not address (virtual-addresses are unique objects)
                    # 1 = Increment vip addresses, all vips use the same port (creates virtual-address objects)

printVips=0         # Don't print vips - meant for configs that don't include virtual servers
poolMaxUse=1        # Maximum number of times a pool can be used

## VIP details
vsPrefix="vs"       # Prefix for all virtual server names
vsPostfix=""        # Postfix for all virtual server names
vipPort=80          # Virtual server listening port (all vips)

aNet_v=10           # 1st octet of vip addresses
bNet_v=101          # 2nd octet of vip addresses
cNet_v=50           # 3rd octet of vip addresses, will be incremented as-necessary
dNet_v=1            # Starting address 

## Pool/Node details
pPrefix="p"         # Prefix for all pool names
nodePort=80         # listening port for pool members
memberCount=5       # members in each pool

aNet_p=20           # 1st octet for pool members
bNet_p=1            # 2nd octet for pool members
cNet_p=0            # 3rd octet for pool members, will be incremented as-necessary
dNet_p=1            # Starting address for pool members

mk_partitions=0     # 0 = do not create multiple partitions
                    # 1 = Create multiple partitions
partNum=101         # Initial partition name - will increment  

##
## No user-modifiable variables below this point
##
poolUseCount=0      # Number of vips using this pool
poolNum=1           # Current pool number
uniqueMbrCount=0    # Total unique pool members
vipTotal=0          # Total vips created so far
lastPoolName=""     #

### Start
# If v10, write default bigip.conf settings
(($version == 10)) && {
  echo "shell write partition Common"
  echo "configsync { auto detect enable }"
}

for (( vip=1; $vip <= $VIPS; vip++ )); do
  part="part${partNum}"
  (($mk_partitions)) && { vipName=$(printf "/%s/%s%05d%s" $part $vsPrefix $vip $vsPostfix); } ||
                        { vipName=$(printf "%s%05d%s" $vsPrefix $vip $vsPostfix); }

  # Generate virtual server address - might use unique addresses (normal), 
  # or might use the same IP address and different ports (creates only one virtual-address object)
  (($mk_partitions)) && { vipAddress=$(printf "/%s/%d.%d.%d.%d:%d" $part $aNet_v $bNet_v $cNet_v $dNet_v $vipPort); }
                        { vipAddress=$(printf "%d.%d.%d.%d:%d" $aNet_v $bNet_v $cNet_v $dNet_v $vipPort); }

  # Update vip address for next vip
  (($uniqueVipAddr)) && {
    # No more than 250 used in each /24
    (($dNet_v > 250)) && { dNet_v=1; ((cNet_v++)); } || { ((dNet_v++)); }
  } || {
    ((vipPort++))
  }

  # Determine pool to be used and create pool name
  [[ -z "$pool_id" ]] && {
    (($mk_partitions)) && { pool_id=$(printf "/%s/%s%05d" $part $pPrefix $poolNum); } ||
                          { pool_id=$(printf "%s%05d" $pPrefix $poolNum); }
    poolName=$pool_id

    ((poolUseCount++))

    # determine pool members
    for (( c=0; $c < $memberCount; c++ )); do
      ((uniqueMbrCount++))
      if (( $dNet_p > 255 )); then dNet_p=0; ((cNet_p++)); fi
      (($mk_partitions)) && {
        nodes="$nodes $(printf '/%s/%d.%d.%d.%d:%d' $part $aNet_p $bNet_p $cNet_p $dNet_p $nodePort)"
      } || {
        nodes="$nodes $(printf '%d.%d.%d.%d:%d' $aNet_p $bNet_p $cNet_p $dNet_p $nodePort)"
      }
      ((dNet_p++))
      # Increment the "B" network - probably not suitable for most scenarios
      if [[ $((uniqueMbrCount%1000)) -eq 0 ]]; then 
        echo "Incrementing B (uniqueMbrCount: $uniqueMbrCount)" 1>&2
        ((bNet_p++)); cNet_p=0; dNet_p=1
      fi 
    done
  } || {
    poolName=$pool_id
    ((poolUseCount++))
  }

  # If the pool hasn't been defined, do so now
  [[ $poolName != $lastPoolName ]] && {
    (($version == 11)) && { printf "ltm pool %s { members { %s }}\n" $poolName "$nodes"; }
    (($version == 10)) && { printf "pool %s { members { %s }}\n" $poolName "$nodes"; }
  }
  if [[ -n "$nodes" ]]; then unset nodes; fi

  if (( $poolUseCount >= $poolMaxUse )); then
    unset pool_id
    poolUseCount=0
    ((poolNum++))
  fi

  # Create the full vip definition 
  if (($printVips)); then
    (($version == 11)) && { printf "ltm virtual %s { destination %-21s pool %s profiles { fastL4 }}\n" $vipName $vipAddress $poolName; }
    (($version == 10)) && { printf "virtual %s { destination %-21s pool %s profiles { fastL4 }}\n" $vipName $vipAddress $poolName; }
  fi

  # save the current pool name to see if it changes during the next iteration
  lastPoolName=$poolName

  ((vipTotal++))

  # If partitions are being used, ensure the correct number of vips per-partiton
  (($mk_partitions)) && { (( !$vipTotal%1000 )) && { ((partNum++)); }; }
done

