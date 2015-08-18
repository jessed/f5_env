#! /bin/bash

VIPS=50
vipTotal=1
mk_partitions=0
partNum=101


## VIP addresses
vsPrefix="v6-vs"
vsPostfix="_https"
vipPort=443

extNetPrefix='fd00:0:101'
cNet_v=20; dNet_v=51


## Pool and Node details
pPrefix="v6-p"

poolUseCount=1
poolMaxUse=1
poolNum=1
nodeCount=4
nodeReuse=1

intNetPrefix='fd00:0:102'
cNet_p=102; dNet_p=1

###
### Start
###
for (( vip=1; $vip <= $VIPS; vip++ )); do

  # determine vip name
  if   [ $vip -lt 10 ];    then num="00${vip}"
  elif [ $vip -lt 100 ];   then num="0${vip}"
  #elif [ $vip -lt 1000 ];  then num="0${vip}"
  else                          num=${vip}
  fi
  vipName="${vsPrefix}${num}${vsPostfix}"

  # generate vip address
  vipAddress=$(printf "%s::%d:%x.%d" $extNetPrefix $cNet_v $dNet_v $vipPort)
  ((dNet_v++))

  # determine pool to be used
  # if pools are used multiple times and the current pool has not been used $poolMaxUse, then
  # $pool_id will still be populated. If a new pool is needed, $pool_id will have been unset below
  if [ -z "$pool_id" ]; then
    if   [ $poolNum -lt 10 ];   then pool_id="00${poolNum}"
    elif [ $poolNum -lt 100 ];  then pool_id="0${poolNum}"
    #elif [ $poolNum -lt 1000 ]; then pool_id="0${poolNum}"
    else                             pool_id="${poolNum}"
    fi
    poolName=${pPrefix}$pool_id
    ((poolUseCount++))

    # determine pool members
    node1=$(printf "%s::%d:%x.80" $intNetPrefix $cNet_p $dNet_p); ((dNet_p++))
    if (($dNet_p > 100)); then dNet_p=1; ((cNet_p++)); fi
    node2=$(printf "%s::%d:%x.80" $intNetPrefix $cNet_p $dNet_p); ((dNet_p++))
    if (($dNet_p > 100)); then dNet_p=1; ((cNet_p++)); fi
    node3=$(printf "%s::%d:%x.80" $intNetPrefix $cNet_p $dNet_p); ((dNet_p++))
    if (($dNet_p > 100)); then dNet_p=1; ((cNet_p++)); fi
    node4=$(printf "%s::%d:%x.80" $intNetPrefix $cNet_p $dNet_p); ((dNet_p++))
    if (($dNet_p > 100)); then dNet_p=1; ((cNet_p++)); fi

  else # Previous pool is being reused
    poolName=${pPrefix}$pool_id
    ((poolUseCount++))

  fi

  # Create vip and pool configuration taking into account whether partitions are required or not
  if [ $mk_partitions == 0 ]; then
    #printf "ltm pool    %s { members {   %s %s %s %s } monitor gateway_icmp }\n" $poolName $node1 $node2 $node3 $node4
    #printf "ltm virtual %s { destination %s pool %s profiles { http tcp }}\n" $vipName $vipAddress $poolName
    printf "ltm virtual %s { destination %s pool %s profiles { clientssl { context clientside } http tcp }}\n" $vipName $vipAddress $poolName
  else
    printf "ltm pool /part%d/%s { members { /part%d/%s /part%d/%s } monitor gateway_icmp }\n" $partNum $poolName $partNum $node1 $node2 $partNum
    printf "ltm virtual /part%d/%s { destination /part%d/%s pool /part%d/%s profiles { /Common/fastL4 }}\n" $partNum $partNum $vipName $poolName
  fi

  # increment the vip count
  ((vipTotal++))

  # If pool has been used max number of times, unset $pool_id and increment $poolNum
  if (( $poolUseCount > $poolMaxUse )); then
    unset pool_id
    poolUseCount=1
    ((poolNum++))
  fi

  # if the correct number of vips has been created for this partition, increment the partition number
  if [ $((vipTotal%1000)) -eq 1 ]; then
    ((partNum++))
  fi

done
