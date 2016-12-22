# ~/local/devices

###
### Seattle Performance test
###

## 4304, VzW
alias tc10350-1='ssh root@tc10350-1'

## vCMP v6 management testing (VzW, Haitao)
alias client01='ssh jessed@client01'
alias server01='ssh jessed@server01'

##VE/VMs
alias ve01='ssh root@ve01'
alias ve02='ssh root@ve02'
alias ve03='ssh root@ve03'
alias ve04='ssh root@ve04'

# vCMP guests
alias vcmp01='ssh  root@vcmp01'
alias vcmp02='ssh  root@vcmp02'
alias vcmp03='ssh  root@vcmp03'
alias vcmp04='ssh  root@vcmp04'
alias vcmp05='ssh  root@vcmp05'
alias vcmp06='ssh  root@vcmp06'
alias vcmp07='ssh  root@vcmp07'
alias vcmp08='ssh  root@vcmp08'

alias vcmp01a='ssh root@vcmp01a'
alias vcmp02a='ssh root@vcmp02a'
alias vcmp03a='ssh root@vcmp03a'
alias vcmp04a='ssh root@vcmp04a'

alias vcmp01b='ssh root@vcmp01b'
alias vcmp02b='ssh root@vcmp02b'
alias vcmp03b='ssh root@vcmp03b'
alias vcmp04b='ssh root@vcmp04b'

## TC Hypervisors
# VMware user/pass: root / ihtfcp,sswa  ( vcenter: administrator@pl.itc / FuckY0u! )
alias tchv01='ssh tchv01'             # Hypervisor, VMware
alias tchv02='ssh tchv02'             # Hypervisor, VMware
alias tchv03='ssh tchv03'             # Hypervisor, KVM
alias tchv04='ssh tchv04'             # Hypervisor, KVM

## Ixia chassis and appliance ports
alias tcixc01='telnet tcixc01 8021'           # XGS-12; may no longer be valid after upgrade to native linux IxServer
alias tcixc02='telnet tcixc02 8021'           # XM-12
alias tcixa01-1='telnet -l root tcixa01-1'    # appliance root password: 1x1ac0m.c0m
alias tcixa01-2='telnet -l root tcixa01-2'
alias tcixa01-3='telnet -l root tcixa01-3'
alias tcixa01-4='telnet -l root tcixa01-4'
alias tcixa02-1='telnet -l root tcixa02-1'
alias tcixa02-2='telnet -l root tcixa02-2'
alias tcixa02-3='telnet -l root tcixa02-3'
alias tcixa02-4='telnet -l root tcixa02-4'
alias tcixa03-1='telnet -l root tcixa03-1'
alias tcixa03-2='telnet -l root tcixa03-2'
alias tcixa03-3='telnet -l root tcixa03-3'
alias tcixa03-4='telnet -l root tcixa03-4'
alias tcixa04-1='telnet -l root tcixa04-1'
alias tcixa04-2='telnet -l root tcixa04-2'
alias tcixa04-3='telnet -l root tcixa04-3'
alias tcixa04-4='telnet -l root tcixa04-4'
alias tcixa05-1='telnet -l root tcixa05-1'
alias tcixa05-2='telnet -l root tcixa05-2'
alias tcixa05-3='telnet -l root tcixa05-3'
alias tcixa05-4='telnet -l root tcixa05-4'
alias tcixa06-1='telnet -l root tcixa06-1'
alias tcixa06-2='telnet -l root tcixa06-2'
alias tcixa06-3='telnet -l root tcixa06-3'
alias tcixa06-4='telnet -l root tcixa06-4'
alias tcixa07-1='telnet -l root tcixa07-1'
alias tcixa07-2='telnet -l root tcixa07-2'
alias tcixa07-3='telnet -l root tcixa07-3'
alias tcixa07-4='telnet -l root tcixa07-4'


## VIPRION chassis and slots
alias tcvip01='ssh   -t root@tcvip01'     # 2400
alias tcvip01-1='ssh -t root@tcvip01-1'
alias tcvip01-2='ssh -t root@tcvip01-2'
alias tcvip01-3='ssh -t root@tcvip01-3'   # 2250 on loan from ptt
alias tcvip01-4='ssh -t root@tcvip01-4'   # 2250 on loan from ptt
alias tcvip02='ssh   -t root@tcvip02'     # 2400
alias tcvip02-1='ssh -t root@tcvip02-1'
alias tcvip02-2='ssh -t root@tcvip02-2'
alias tcvip03='ssh   -t root@tcvip03'     # 4400
alias tcvip03-1='ssh -t root@tcvip03-1'
alias tcvip03-2='ssh -t root@tcvip03-2'
alias tcvip03-3='ssh -t root@tcvip03-3'
alias tcvip03-4='ssh -t root@tcvip03-4'
alias tcvip04='ssh   -t root@tcvip04'     # 4400
alias tcvip04-1='ssh -t root@tcvip04-1'
alias tcvip04-2='ssh -t root@tcvip04-2'
alias tcvip04-3='ssh -t root@tcvip04-3'
alias tcvip04-4='ssh -t root@tcvip04-4'
alias tcvip05='ssh   -t root@tcvip05'     # 4480 (performance)
alias tcvip05-1='ssh -t root@tcvip05-1'
alias tcvip05-2='ssh -t root@tcvip05-2'
alias tcvip05-3='ssh -t root@tcvip05-3'
alias tcvip05-4='ssh -t root@tcvip05-4'
alias tcvip06='ssh   -t root@tcvip06'     # C4800 (Performance)
alias tcvip06-1='ssh -t root@tcvip06-1'
alias tcvip06-2='ssh -t root@tcvip06-2'
alias tcvip06-3='ssh -t root@tcvip06-3'

alias tcvip07='ssh   -t root@tcvip07'     # C4800  (PoC/Performance)
alias tcvip07-1='ssh -t root@tcvip07-1'
alias tcvip07-2='ssh -t root@tcvip07-2'
alias tcvip07-3='ssh -t root@tcvip07-3'
alias tcvip07-4='ssh -t root@tcvip07-4'

alias tcvip08='ssh   -t root@tcvip08'     # 4800
alias tcvip08-1='ssh -t root@tcvip08-1'
alias tcvip08-2='ssh -t root@tcvip08-2'

alias tcvip09='ssh   -t root@tcvip09'     # 4800
alias tcvip09-1='ssh -t root@tcvip09-1'
alias tcvip09-2='ssh -t root@tcvip09-2'

# Appliances
alias tc2200-1='ssh -t tc2200-1'
alias tc2200-2='ssh -t tc2200-2'
alias tc4200-1='ssh -t tc4200-1'
alias tc4200-2='ssh -t tc4200-2'
alias tc5200-1='ssh -t tc5200-1'
alias tc5200-2='ssh -t tc5200-2'
alias tc7200-1='ssh -t tc7200-1'
alias tc7200-2='ssh -t tc7200-2'
alias tc10200-1='ssh -t tc10200-1'
alias tc10200-2='ssh -t tc10200-2'
alias tc10800-1='ssh -t tc10800-1'
alias tc10800-2='ssh -t tc10800-2'
alias tc12250-1='ssh -t tc12250-1'
alias tc12250-2='ssh -t tc12250-2'
alias tc11050-1='ssh -t tc11050-1'

# Infrastructure systems / Hypervisors
alias tcsrv01='ssh tcsrv01'           # General purpose linux workstation
alias a7048='ssh a7048'               # Arista admin/test switch
alias a7508='ssh a7508'               # core switch, > 40Gbs devices
alias a7508-1='ssh a7508-1'           # core switch, > 40Gbs devices
alias a7508-2='ssh a7508-2'           # core switch, > 40Gbs devices
alias tc6248-1='telnet tc6248-1'      # mgmt switch
alias tc6248-2='telnet tc6248-2'      # mgmt switch

# VMware user/pass: root / ihtfcp,sswa  ( vcenter: administrator@pl.itc / FuckY0u! )
alias tchv01='ssh tchv01'             # Hypervisor, VMware  - root / ihtfcp,sswa
alias tchv02='ssh tchv02'             # Hypervisor, VMware  - root / ihtfcp,sswa
alias tchv03='ssh tchv03'             # Hypervisor, KVM
alias tchv04='ssh tchv04'             # Hypervisor, KVM


###
### Seattle PoC/Demo
###
## demo VMs
alias sea-analytics='ssh -t root@sea-analytics'
alias sea-bind-1='ssh user@sea-bind-1'
alias sea-dns-1='ssh root@sea-dns-1'

## demo DUTs
alias sea-c2200-1='ssh -t root@sea-c2200-1'
alias sea-c2400-1='ssh -t root@sea-c2400-1'
alias sea-c4400-1='ssh -t root@sea-c4400-1'
alias sea-2200s-1='ssh -t root@sea-2200s-1'
alias sea-2200s-2='ssh -t root@sea-2200s-2'
alias sea-10200v-1='ssh -t root@sea-10200v-1'
alias sea-10200v-2='ssh -t root@sea-10200v-2'
alias sea-12250v-1='ssh -t root@sea-12250v-1'

## demo switches and servers
alias sea-sw-13t='ssh admin@sea-sw-13t'
alias cs='ssh itc@sea-cs-a14.itc.f5net.com'
alias sea-tcsrv-1='ssh sea-tcsrv-1'
alias sea-tcsrv-2='ssh sea-tcsrv-2'


###
### London
###
alias a1='ssh root@172.30.107.136'
alias b1='ssh root@172.30.107.138'
alias a1-3hassis='ssh root@172.30.107.130'
alias b1-3hassis='ssh root@172.30.107.40'
alias uktest='ssh root@172.30.107.135'

