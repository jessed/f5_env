#! /bin/bash

firstRR=1
newRecords=10
domain="f5test.net"

rrPrefix="host"
rrSuffix=""

aNet=10
bNet=10
cNet=1
dNet=1

hostAddr="10.111.10.1"

sed -e s/ZONE.ZONE/$domain/g zone.template > ${domain}.zone

list=""
total=$(($newRecords + firstRR))
for (( rr=$firstRR; $rr <= $newRecords; rr++)); do

  # generate IP address
  if [[ $dNet > 254 ]]; then
    dNet=1; ((cNet++))
  else
    ((dNet++))
  fi
  addr="${aNet}.${bNet}.${cNet}.${dNet}"

  # create new RR text
  entry=$(printf "%s%05d%s" ${rrPrefix} ${rr} ${rrSuffix})
  #printf "%-30s A     %-20s\n" ${entry} ${addr} >> ${domain}.zone
  printf -v curRR "%-30s A     %-20s\n" ${entry} ${addr}

  # Add this entry to the list
  list="${list}${curRR}"

done

#echo -en $list >> ${domain}.zone
printf "$list" >> ${domain}.zone

