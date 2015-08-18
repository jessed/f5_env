#! /bin/bash

aNet=20
bNet=1
cNet=1
dNet=1
mask="255.255.255.0"

maxVlans=8192

test -f vlan_def && rm vlan_def
test -f self_def && rm self_def
test -f domain_def && rm domain_def

for ((vlanId=1; $vlanId <= $maxVlans; vlanId++)); do
  if [ $vlanId -lt 10 ];     then vlanName="v000${vlanId}"
  elif [ $vlanId -lt 100 ];  then vlanName="v00${vlanId}"
  elif [ $vlanId -lt 1000 ]; then vlanName="v0${vlanId}"
  else                          vlanName="v${vlanId}"
  fi

  if [[ $cNet -gt 254 ]]; then
    cNet=1
    ((bNet++))
  fi

  addVlan="vlan $vlanName tag $vlanId trunks tagged mytrunk"
  addSelf="self $aNet.$bNet.$cNet.${dNet}%${vlanId} netmask $mask vlan $vlanName"
  addDomain="route domain $vlanId { vlans $vlanName }"

  vList="$vList\n$addVlan"
  aList="$aList\n$addSelf"
  dList="$dList\n$addDomain"

done

echo -en $vList > vlan_def
echo -en $aList > self_def
echo -en $dList > domain_def
