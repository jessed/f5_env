#! /bin/bash

## Create the configured number of wide-ips, each with unique pools and virtual servers.
new_objects=3000
## Virtual server components
startWip=1
stopWip=$(calc $startWip + $new_objects - 1)
cfg_out="be1224-wide_ips.conf"

#echo "#Starting WIP id: $startWip; Stop id: $stopWip"

wPrefix="wip"
sPrefix="srv"
pPrefix="pool"
aPrefix="app"
aNet=10
#bNet=107
cNet=1
dNet=1

prodString="product generic-host virtual-servers"

##
## start
##
test -f $cfg_out && rm $cfg_out

# Define Wide-IP, Pool, and Server names
for (( w=$startWip; $w <= $stopWip; w++)); do
  if   [ $w -lt 10 ];   then
    wip_id="${wPrefix}000${w}"
    srv_id="${sPrefix}000${w}"
    app_id="${aPrefix}000${w}"
    pool_id="${pPrefix}000${w}"
  elif [ $w -lt 100 ];  then
    wip_id="${wPrefix}00${w}"
    srv_id="${sPrefix}00${w}"
    app_id="${aPrefix}00${w}"
    pool_id="${pPrefix}00${w}"
  elif [ $w -lt 1000 ]; then
    wip_id="${wPrefix}0${w}"
    srv_id="${sPrefix}0${w}"
    app_id="${aPrefix}0${w}"
    pool_id="${pPrefix}0${w}"
  else
    wip_id="${wPrefix}${w}"
    srv_id="${sPrefix}${w}"
    app_id="${aPrefix}${w}"
    pool_id="${pPrefix}${w}"
  fi


  srvA="${srv_id}a"; srvA_addr="$aNet.106.$cNet.$dNet"; appA="${srvA}-${app_id}"; poolA="${pool_id}a"
  srvB="${srv_id}b"; srvB_addr="$aNet.107.$cNet.$dNet"; appB="${srvB}-${app_id}"; poolB="${pool_id}b"
  srvC="${srv_id}c"; srvC_addr="$aNet.108.$cNet.$dNet"; appC="${srvC}-${app_id}"; poolC="${pool_id}c"
  srvA_dest="destination $srvA_addr:80"
  srvB_dest="destination $srvB_addr:80"
  srvC_dest="destination $srvC_addr:80"
  dcA="datacenter dc1"
  dcB="datacenter dc2"
  dcC="datacenter dc3"

  # pools
  pool1="gtm pool $poolA {members {${srvA}:${appA} {order 0}} verify-member-availability disabled}"
  pool2="gtm pool $poolB {members {${srvB}:${appB} {order 0}} verify-member-availability disabled}"
  pool3="gtm pool $poolC {members {${srvC}:${appC} {order 0}} verify-member-availability disabled}"
  pools="$pool1\n$pool2\n$pool3"
  
  # servers
  srvA="gtm server $srvA {addresses { $srvA_addr { device-name $srvA }} $dcA $prodString { $appA { $srvA_dest }}}"
  srvB="gtm server $srvB {addresses { $srvB_addr { device-name $srvB }} $dcB $prodString { $appB { $srvB_dest }}}"
  srvC="gtm server $srvC {addresses { $srvC_addr { device-name $srvC }} $dcC $prodString { $appC { $srvC_dest }}}"
  servers="$srvA\n$srvB\n$srvC"

  # wide-ip
  wip="gtm wideip ${wip_id}.f5test.net { pools { $poolA { order 0 } $poolB { order 1 } $poolC { order 2 }}}"

  #current="$pool1\n$pool2\n$pool3\n$srvA\n$srvB\n$srvC\n$wip\n"
  current="$servers\n$pools\n$wip"
  output="${output}\n${servers}\n${pools}\n${wip}"
  #output="${output}\n${current}"

  ((dNet++))
  # Handle /24 subnet boundry correctly
  if (( $dNet > 254 )); then
    dNet=1
    ((cNet++))
    echo -e $output
    unset output
  fi
done

echo -e $output
