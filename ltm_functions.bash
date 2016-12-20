# ltm_helpers.bash
# functions to speed up common tasks when working with BIG-IP

# send the specified public key to the ~/.ssh/authorized_keys file on the remote host
# SYNTAX:       synckey <host> [user] [/path/to/public/key]
# default user: root
# default pub:  ~/.ssh/ltm_shared_key.pub
synckey() {
  if [[ -z "$1" ]]; then
    echo "USAGE: synckey <hostname> [username] [pub key file]";
    echo "Defaults to adding the contents of ~/.ssh/ltm_shared_key.pub"
    echo "to ~/.ssh/authorized_keys on the remote system"
    return
  else
    HOST=$1
  fi
  if [ -z "$2" ]; then USER=root; else USER=$2; fi
  if [ -z "$3" ]; then KEY="$HOME/.ssh/ltm_shared_key.pub"; else KEY=$3; fi

  KEYS=$(cat $KEY)
  ssh ${USER}@${HOST} "echo $(< $KEY) >> ~/.ssh/authorized_keys"
}

# Takes several steps to prepare the remote host environment.
# Most of the changes are not enabled until you enter the 'src'
# command, which sources the ~/.env.ltm
# SYNTAX:  ltm_env <host>
ltm_env() {
  local ENVFILE="${HOME}/ltm_helpers/env.ltm"
  local VIMRC="${HOME}/ltm_helpers/vimrc.ltm"

  if [[ -n "$1" ]]; then
    host=$1
  else
    echo "USAGE: ltm_env <ltm_host>"
    return
  fi

  # copy the new environment file into place
  scp ${ENVFILE} root@${host}:/shared/env.ltm
  scp ${VIMRC}   root@${host}:/shared/vimrc.ltm
  ssh root@${host} "ln -sf /shared/env.ltm .env.ltm"
  ssh root@${host} "ln -sf /shared/vimrc.ltm .vimrc"

  # update existing .bash_profile to source new environment file
  ssh root@${host} "echo \"alias src='cd ; source /shared/env.ltm'\">> .bash_profile"
  ssh root@${host} "echo \"source /shared/env.ltm\">> .bash_profile"

  #  don't change to the /config directory on login
  ssh root@${host} "sed -i -e \"s/^cd \/config/#cd \/config/\" .bash_profile"

  # Run 'chk_vi_mode()' on login to set bash vi-mode
  ssh root@${host} "echo -e \"\\nchk_vi_mode\">> .bash_profile"

  # comment out the 'clear' in .bash_logout
  ssh root@${host} "sed -i -e \"s/^clear/#clear/\" .bash_logout"

  # stop printing the motd on login
  ssh root@${host} "touch .hushlogin"

  # bind 'ctrl+l to the bash 'clear-screen' command
  ssh root@${host} "echo 'Control-l: clear-screen' > .inputrc"

  # update sshd_config to accept the $VIMODE environment variable from clients
  #ssh root@${host} "echo 'AcceptEnv  VIMODE' >> /config/ssh/sshd_config"
  #ssh root@${host} "/etc/init.d/sshd restart"

}

# continually flash the screen after the given number of seconds has elapsed
reminder() {
  if [ -z "$1" ]; then timer=180;
  else
    if [ $1 -lt 60 ]; then timer=$((1*60))
    else timer=$1
    fi
  fi
  echo "Reminder will occur in $timer seconds"
  sleep $timer

  while [ 1 ]; do echo -e "\a"; sleep 1; done
}


### watchhost() moved to default bash_functions

# monitor a host and alert when the system starts responding to pings
# doesn't initialize the notification until after the system stops responding
#watchhost() {
#  go=1
#  while [ $go -eq 1 ]; do
#    ping -c1 -W 1 $1 >/dev/null 2>&1
#    if [ $? -eq 0 ]; then
#      #echo "ping succeeded, sleeping"
#      sleep 1
#    else
#      #echo "ping failed, setting go = 0"
#      echo "No echo response, entering notification phase"
#      go=0
#      sleep 1
#    fi
#  done
#
#  while [ 1 ]; do
#    ping -c1 $1 >/dev/null 2>&1
#    if [ $? -ne 0 ]; then
#      sleep 1
#    else
#      echo -e "$1 is up\a"
#      sleep 1
#    fi
#  done
#}

