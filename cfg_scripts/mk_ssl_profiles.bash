#! /bin/bash

## This script just creates an user-defined number of unique client SSL profiles

limit=100000

crt="/config/ssl/ssl.crt/default.crt"
key="/config/ssl/ssl.key/default.key"

Kcerts=$(expr $limit / 1000)
cfg="${Kcerts}K_ssl_profiles-bigip.conf"

#test -f bigip_certs.conf && rm bigip_certs.conf
test -f $cfg && rm $cfg

echo "##ssl profiles" > $cfg
for ((i=1; $i <= $limit; i++)); do
  echo -ne "profile clientssl myssl_${i} {
   defaults from clientssl
   options dont insert empty fragments
}\n\n" >> $cfg
done

echo "Creating $limit ssl profiles complete"
