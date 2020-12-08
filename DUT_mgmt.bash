# ~/local/DUT_mgmt.bash

###
### SSH aliases for CPT resources
###

## PTT
alias i7000-2='ssh i7000-2.pl.pdsea.f5net.com'
alias i7000-4='ssh i7000-4.pl.pdsea.f5net.com'

##VE/VMs
# CPT VE
alias ve01='ssh ve01'    # bs027 - AT&T IP-SEC
alias ve02='ssh ve02'    # bs027 - AT&T IP-SEC


## TC Hypervisors
# VMware user/pass: root / iht... ( esxi: root / iht... )
alias kif='ssh jessed@kif'

## Oslo Servers


## Ixia chassis and appliance ports         # XT80 default root password: 1x1ac0m.c0m
alias tcixc01='ssh -p 8022 admin@xgs12-1.cpt.gtp.f5net.com'     # XGS-12    admin / admin  (SSH and FTP)
alias tcixc02='telnet tcixc02 8021'                             # XM-12


## CPT Hardeware DUTs
alias c4480-1='ssh root@c4480-1.cpt.gtp.f5net.com'
alias c4480-2='ssh root@c4480-2.cpt.gtp.f5net.com'

alias tc12250-1='ssh root@tc12250-1.cpt.gtp.f5net.com'  # 172.22.57.107
alias tc12250-2='ssh root@tc12250-2.cpt.gtp.f5net.com'  # 172.22.57.108

alias tc15800-1='ssh root@i15000-1.cpt.gtp.f5net.com'  # 172.22.57.141
alias tc15800-2='ssh root@i15000-2.cpt.gtp.f5net.com'  # 172.22.57.157

alias i5000-1='ssh root@i5000-1.cpt.gtp.f5net.com'


# Infrastructure systems / Hypervisors
alias tcsrv01='ssh tcsrv01'           # General purpose linux workstation
alias hermes='ssh tcsrv01'           # General purpose linux workstation
alias a7508='ssh a7508'               # core switch, > 40Gbs devices
alias a7508-1='ssh a7508-1'           # core switch, > 40Gbs devices
alias a7508-2='ssh a7508-2'           # core switch, > 40Gbs devices

