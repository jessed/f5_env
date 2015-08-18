#! /bin/bash

firstRR=1
newRecords=10000

rrPre="host"
rrSuf=""
domain="f5test.net"

hostAddr="10.111.10.1"

list=""
count=1
for (( rr=$firstRR; $rr <= $newRecords; rr++)); do
  num=$(expr $count % 4 + 1) 
  host="${hostAddr}${num}"
  # create new RR text
  printf -v curRR "${rrPre}%05d${rrSuf}           A      %s\n" ${rr} ${host}


  if [[ $count -eq 250 ]]; then
    echo -e $list
    list=""
    count=1
  fi

  # Add this entry to the list
  list="${list}${curRR}\n"
  ((count++))
done

echo -e $list

