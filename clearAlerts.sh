#!/bin/bash
set -v
tmsh modify sys dns name-servers add {172.22.48.10}
tmsh modify sys ntp servers add {172.22.48.10}
# the above changes are not persistent
registrationKey=`tmsh show sys license | grep "Registration key" | awk '{print $3}'`
hardwareType=`tmsh show sys hardware | grep Type | tail -n1 | awk '{print $2}'`
echo "recycling license on $HOSTNAME..."
/usr/local/bin/SOAPLicenseClient --verbose --basekey $registrationKey
{
if [[ $hardwareType == Z* ]] ; then
echo "$HOSTNAME is Virtual Edition type: $hardwareType"
exit 0
elif [[ $hardwareType == A* ]] ; then
echo "Clearing alerts on $HOSTNAME VIPRION Type: $hardwareType"
for i in 0 1 2 3 4; do for j in 0 1; do lcdwarn -c "${i}" "${j}"; done; done
else
echo "Clearing alerts on $HOSTNAME Non-VIPRION Type: $hardwareType"
for i in 0 1 2 3 4 5; do lcdwarn -c "${i}" 0; done
fi
}