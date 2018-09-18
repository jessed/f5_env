## All alias entries should be in here.
alias ls='ls --color=always'
alias ll='ls -l --color=always'
alias l1='ls -1 --color=always'
alias lh='ls -lh --color=always'
alias la='ls -lA --color=always'
alias ld='ls -ld --color=always'

alias vi=vim                                        # convenience alias, need to deprecate
alias mv='mv -i'                                    # Because I'm becoming a coward...
alias cp='cp -i'                                    # Because I'm still a coward
alias s='sudo -E'                                   # convenience alias
alias duh='du -hd 1'
alias last='last | head -20'
alias grep='grep -i --color=auto -E'
alias lock='xlock -mode blank'
alias syncdir='rsync -auzv --exclude="*.swp"'
alias lscr='screen -xRRS standard -p1'              # local screen session
alias rs='screen -c ~/.screen/remote -xRRS remote'  # remote screen session
alias perf='screen -c ~/.screen/perf -xRRS perf'    # performance screen session
alias stat='stat -x'
#alias whois='whois -H'
alias tail='tail -n20'          # specifying the number of lines a second time fails on mac

alias ping='ping -n'
alias traceroute='traceroute -nw 1'
alias conns='netstat -anf inet'


SOURCES=""
SOURCES="$SOURCES .aws_functions.bash .apt_aliases.bash .virt_aliases.bash .centos_aliases.bash"

for s in $SOURCES; do
  test -f $HOME/${s} && source $HOME/${s}
done

