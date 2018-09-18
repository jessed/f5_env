# ~/.bashrc: executed by bash(1) for non-login shells.
# ~/.bashrc

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

test -f /etc/bashrc       && . /etc/bashrc        # system-wide bashrc
test -f ~/.bash_aliases   && . ~/.bash_aliases    # bash aliases
test -f ~/.bash_functions && . ~/.bash_functions  # bash utility functions
test -f ~/.bash_local     && . ~/.bash_local      # programming language environment

# Add to what is defined in /etc/environment
if [ ! $PATHSRCD ]; then
  PATH="$HOME/local/bin:$PATH:/sbin:/usr/sbin:/usr/local/sbin"
  export PATHSRCD=1
fi

test -d ~/.HISTORY || mkdir ~/.HISTORY

export HISTCONTROL=ignoredups
export HISTFILE="$HOME/.HISTORY/$(date +%Y-%m).bash_history"
export HISTTIMEFORMAT="%F %T  "
export HISTFILESIZE=300000
export HISTSIZE=300000
export HISTIGNORE="&:ls:[bf]g:exit"

## Environment variables
export EDITOR=vim
export VISUAL=vim
export FCEDIT=vim
export HOSTFILE="/etc/hosts"

# Other
export PDSH_RCMD_TYPE='ssh'
export PDSH_SSH_ARGS_APPEND='-l root'


# Bash options
shopt -s checkwinsize # update the values of LINES and COLUMNS.
shopt -s histappend   # Append to the history file, do not overwite
shopt -s cmdhist      # save multi-line commands
shopt -s hostcomplete # attempt to perform hostname completion following a '@' sign

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# Determine if this is a Debian variant to control whether Debian-specific
# blocks are executed
if [[ $(grep -q Ubuntu /etc/issue) -eq 0 ]]; then export DEBIAN=1; fi

# set variable identifying the chroot you work in (used in the prompt below)
(($DEBIAN)) && {
  if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
      debian_chroot=$(cat /etc/debian_chroot)
  fi
}

# enable color support
if [ "$TERM" != "dumb" ]; then eval "`dircolors -b`"; fi

# populate cli completion data
if [ -f /etc/bash_completion ]; then . /etc/bash_completion; fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


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


# Enable VI-mode if VIMODE=1 is passed in through ssh
chk_vi_mode

# Using this because UDF instances don't received environment variables sent with 'SendEnv' directive
set -o vi


# Enabled the oslo data nic
start_datanic

# Update the hostname
set_hostname


PROMPT_COMMAND=mk_prompt
