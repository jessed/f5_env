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


## Performance Lab Hypervisors
# VMware user/pass: root / ihtfcp,sswa  
alias tchv01='ssh tchv01'             # VMware  user/pass: root / <ihtfcp...>
alias tchv02='ssh tchv02'             # VMware  user/pass: root / <ihtfcp...>
alias tchv03='ssh tchv03'             # KVM
alias tchv04='ssh tchv04'             # KVM

## Ixia chassis and appliance ports
alias tcixc01='telnet tcix01 8021'
alias tcixc02='telnet tcix02 8021'
alias tcixa01-1='telnet tcixa01-1'    # appliance root password: 1x1ac0m.c0m
alias tcixa01-2='telnet tcixa01-2'
alias tcixa01-3='telnet tcixa01-3'
alias tcixa01-4='telnet tcixa01-4'
alias tcixa02-1='telnet tcixa02-1'
alias tcixa02-2='telnet tcixa02-2'
alias tcixa02-3='telnet tcixa02-3'
alias tcixa02-4='telnet tcixa02-4'
alias tcixa03-1='telnet tcixa03-1'
alias tcixa03-2='telnet tcixa03-2'
alias tcixa03-3='telnet tcixa03-3'
alias tcixa03-4='telnet tcixa03-4'
alias tcixa04-1='telnet tcixa04-1'
alias tcixa04-2='telnet tcixa04-2'
alias tcixa04-3='telnet tcixa04-3'
alias tcixa04-4='telnet tcixa04-4'
alias tcixa05-1='telnet tcixa05-1'
alias tcixa05-2='telnet tcixa05-2'
alias tcixa05-3='telnet tcixa05-3'
alias tcixa05-4='telnet tcixa05-4'
alias tcixa06-1='telnet tcixa06-1'
alias tcixa06-2='telnet tcixa06-2'
alias tcixa06-3='telnet tcixa06-3'
alias tcixa06-4='telnet tcixa06-4'
alias tcixa07-1='telnet tcixa07-1'
alias tcixa07-2='telnet tcixa07-2'
alias tcixa07-3='telnet tcixa07-3'
alias tcixa07-4='telnet tcixa07-4'


## TC DUTs
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
alias tcvip06='ssh   -t root@tcvip06'     # 4480 (demos/performance)
alias tcvip06-1='ssh -t root@tcvip06-1'
alias tcvip06-2='ssh -t root@tcvip06-2'
alias tcvip06-3='ssh -t root@tcvip06-3'

alias tcvip07='ssh   -t root@tcvip07'     # 2400  (demos/performance)
alias tcvip07-1='ssh -t root@tcvip07-1'
alias tcvip07-2='ssh -t root@tcvip07-2'

alias tcvip08='ssh   -t root@tcvip08'     # 4800
alias tcvip08-1='ssh -t root@tcvip08-1'
alias tcvip08-2='ssh -t root@tcvip08-2'

alias tcvip09='ssh   -t root@tcvip09'     # 4800
alias tcvip09-1='ssh -t root@tcvip09-1'
alias tcvip09-2='ssh -t root@tcvip09-2'

# Current platforms (appliances)
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
alias tc12250-1='ssh -t tc12250-1'
alias tc12250-2='ssh -t tc12250-2'

# older platforms (appliances)
alias tc11050-1='ssh -t tc11050-1'
alias tc8950-1='ssh  -t tc8950-1'
alias tc8950s-1='ssh -t tc8950s-1'
alias tc8900-1='ssh  -t tc8900-1'
alias tc8900-2='ssh  -t tc8900-2'
alias tc8800-1='ssh  -t tc8800-1'
alias tc6400-1='ssh  -t tc6400-1'
alias tc6800-1='ssh  -t tc6800-1'
alias tc6900-1='ssh  -t tc6900-1'
alias tc3900-1='ssh  -t tc3900-1'
alias tc3600-1='ssh  -t tc3600-1'
alias tc1600-1='ssh  -t tc1600-1'

