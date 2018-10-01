#! /bin/bash

firstRR=1
newRecords=20000
domain="f5test.net"

rrPrefix="host"
rrSuffix=""

aNet=10
bNet=10
cNet=1
dNet=1

sed -e s/ZONE.ZONE/$domain/g zone.template > ${domain}.zone

list=""

for (( rr=$firstRR; $rr <= $newRecords; rr++)); do

  # generate IP address
  if (( $dNet > 254 )); then
    dNet=1; ((cNet++))
    if (( $cNet > 254 )); then
      cNet=1; ((bNet++))
    fi
  fi
  addr="${aNet}.${bNet}.${cNet}.${dNet}"

  # create new RR text
  entry=$(printf "%s%05d%s" ${rrPrefix} ${rr} ${rrSuffix})
  #printf "%-30s A     %-20s\n" ${entry} ${addr} >> ${domain}.zone
  printf -v curRR "%-30s A     %-20s\n" ${entry} ${addr}

  # Add this entry to the list
  list="${list}${curRR}"

  ((dNet++))
done


#printf "$list"
printf "$list" >> ${domain}.zone

