# ~/.bashrc: executed by bash(1) for non-login shells.
# ~/.bashrc

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

test -f /esxi.bash_aliases   && source /esxi.bash_aliases    # bash aliases
test -f /esxi.bash_functions && source /esxi.bash_functions  # bash utility functions

export EDITOR=vi


## custom prompt
PROMPT_DIRTRIM=4
SCRN='\[\ek$(echo -n M${WINDOW})\e\\\]'
TITLE='\[\e]0;\u@\h\a'
BLINK="\[\e[5m\]"
CLR="\[\e[0m\]"
GREEN="\[\e[0;32m\]"
RED="\[\e[0;31m\]"
BLUE="\[\e[0;34m\]"
CYAN="\[\e[0;36m\]"
PURPLE="\[\e[0;35m\]"
BROWN="\[\e[0;33m\]"
LTBLUE="\[\e[1;34m\]"
LTGREEN="\[\e[1;32m\]"
LTRED="\[\e[1;31m\]"
LTCYAN="\[\e[1;36m\]"
YELLOW="\[\e[1;33m\]"
WHITE="\[\e[1;37m\]"

#custom prompt
mk_prompt () {
  if [ `id -u` -eq '0' ]; then
    COLOR=${RED}; #COLOR=${RED}${BLINK}
  else
    COLOR=${GREEN}
  fi

  if [[ -n "$WINDOW" ]]; then
    PS1="${COLOR}${SCRN}\h:\w >${CLR}"
  else
    #PS1="${COLOR}\h:\w >${CLR}"    # My standard prompt
    PS1="${RED}[${CYAN}\A${RED}]${CLR}\n${COLOR}\h:\w >${CLR}"
    PS1="${TITLE}$PS1"
  fi
}

PROMPT_COMMAND=mk_prompt

#set -o vi

# vim: set syntax=bash tabstop=2 expandtab:
