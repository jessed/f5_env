# ltm_helpers.bash
# functions to speed up common tasks when working with BIG-IP

# send the specified public key to the ~/.ssh/authorized_keys file on the remote host
# SYNTAX:       synckey <host> [user] [/path/to/public/key]
# default user: root
# default pub:  ~/.ssh/cpt_shared.pub
synckey() {
  if [[ -z "$1" ]]; then
    echo "USAGE: synckey <hostname> [username] [pub key file]";
    echo "Defaults to adding the contents of ~/.ssh/cpt_shared.pub"
    echo "to ~/.ssh/authorized_keys on the remote system"
    return
  else
    HOST=$1
  fi
  if [ -z "$2" ]; then USER=root; else USER=$2; fi
  if [ -z "$3" ]; then KEY="$HOME/.ssh/cpt_shared.pub"; else KEY=$3; fi

  KEYS=$(cat $KEY)
  ssh ${USER}@${HOST} "echo $(< $KEY) >> ~/.ssh/authorized_keys"
}

# Takes several steps to prepare the remote host environment.
# Most of the changes are not enabled until you enter the 'src'
# command, which sources the ~/.env.ltm
# SYNTAX:  ltm_env <host>
ltm_env() {
  local ENVFILE="${HOME}/ltm_helpers/env_files/env.ltm"
  local VIMRC="${HOME}/ltm_helpers/env_files/vimrc.ltm"

  if [[ -n "$1" ]]; then
    host=$1
  else
    echo "USAGE: ltm_env <ltm_host> [port]"
    return
  fi

  if [[ -n "$2" ]]; then
    port=$2
  else
    port=22
  fi

  # copy the new environment file into place
  scp -P ${port} ${ENVFILE} root@${host}:/shared/env.ltm
  scp -P ${port} ${VIMRC}   root@${host}:/shared/vimrc.ltm
  ssh -p ${port} root@${host} "ln -sf /shared/env.ltm .env.ltm"
  ssh -p ${port} root@${host} "ln -sf /shared/vimrc.ltm .vimrc"

  # update existing .bash_profile to source new environment file
  ssh -p ${port} root@${host} "echo \"alias src='cd ; source /shared/env.ltm'\">> .bash_profile"
  ssh -p ${port} root@${host} "echo \"source /shared/env.ltm\">> .bash_profile"

  #  don't change to the /config directory on login
  ssh -p ${port} root@${host} "sed -i -e \"s/^cd \/config/#cd \/config/\" .bash_profile"

  # Run 'chk_vi_mode()' on login to set bash vi-mode
  # ssh -p ${port} root@${host} "echo -e \"\\nchk_vi_mode\">> .bash_profile"

  # comment out the 'clear' in .bash_logout
  ssh -p ${port} root@${host} "sed -i -e \"s/^clear/#clear/\" .bash_logout"

  # stop printing the motd on login
  ssh -p ${port} root@${host} "touch .hushlogin"

  # bind 'ctrl+l to the bash 'clear-screen' command
  ssh -p ${port} root@${host} "echo 'Control-l: clear-screen' > .inputrc"

}

# Perform initial environment customization for AWS instances
aws_env() {
  local ENVFILE="${HOME}/ltm_helpers/env_files/env.ltm"
  local VIMRC="${HOME}/ltm_helpers/env_files/vimrc.ltm"

  if [[ -n "$1" ]]; then
    host=$1
  else
    echo "USAGE: aws_env <ltm_host> [port]"
    return
  fi
  if [[ -n "$2" ]]; then
    port=$2
  else
    port=22
  fi

	# First step: change admin user shell to bash (from tmsh)
	ssh -p ${port} admin@${host} "modify auth user admin shell bash; save sys config"

  # copy the new environment file into place
  scp -P ${port} ${ENVFILE} admin@${host}:/shared/env.ltm
  scp -P ${port} ${VIMRC}   admin@${host}:/shared/vimrc.ltm
  ssh -p ${port} admin@${host} "ln -sf /shared/env.ltm .env.ltm"
  ssh -p ${port} admin@${host} "ln -sf /shared/vimrc.ltm .vimrc"

  # update existing .bash_profile to source new environment file
  ssh -p ${port} admin@${host} "echo \"alias src='source /shared/env.ltm'\">> .bash_profile"
  ssh -p ${port} admin@${host} "echo \"source /shared/env.ltm\">> .bash_profile"

  #  don't change to the /config directory on login
  ssh -p ${port} admin@${host} "sed -i -e \"s/^cd \/config/#cd \/config/\" .bash_profile"

  # Run 'chk_vi_mode()' on login to set bash vi-mode
  ssh -p ${port} admin@${host} "echo -e \"\\nchk_vi_mode\">> .bash_profile"

  # comment out the 'clear' in .bash_logout
  ssh -p ${port} admin@${host} "sed -i -e \"s/^clear/#clear/\" .bash_logout"

  # Add .bash_profile changes to /etc/skel/.bash_profile to persist across re-instantiations
  ssh -p ${port} admin@${host} "echo -e \"\\n\\nalias src='source /shared/env.ltm'\">> /etc/skel/.bash_profile"
  ssh -p ${port} admin@${host} "echo \"source /shared/env.ltm\">> /etc/skel/.bash_profile"
  ssh -p ${port} admin@${host} "sed -i -e \"s/^cd \/config/#cd \/config/\" /etc/skel/.bash_profile"
  ssh -p ${port} admin@${host} "echo -e \"\\nchk_vi_mode\">> /etc/skel/.bash_profile"

  # stop printing the motd on login
  #ssh admin@${host} "touch .hushlogin"

  # bind 'ctrl+l to the bash 'clear-screen' command
  ssh -p ${port} admin@${host} "echo 'Control-l: clear-screen' > .inputrc"
}


## Update AWS linux host environment
aws_linux() {
  if [[ -z "$1" ]]; then
    echo "USAGE: aws_linux {aws_host} [port] (default: 22)"
    return
  else
    host=$1
  fi

  if [[ -n "$2" ]]; then
    port=$2
  else
    port=22
  fi

  files=$(ls ${HOME}/ltm_helpers/env_files/dot*)
  files="$files ${HOME}/ltm_helpers/env_files/sudoers"
  files="$files ${HOME}/ltm_helpers/env_files/nginx.repo"

  for f in $files; do
    new=$(basename $f | sed 's/dot//')
    scp -P ${port} $f ${host}:${new}
  done

  ssh -p ${port} ${host} 'sudo chmod 440 sudoers'
  ssh -p ${port} ${host} 'sudo chown root.root sudoers'
  ssh -p ${port} ${host} "sudo sed -i -e 's/ - set_hostname/# - set_hostname/' /etc/cloud/cloud.cfg"
  ssh -p ${port} ${host} 'ln -s /etc/sysconfig/network-scripts/'
}

## Update local linux VM host environment
vm_linux() {
  if [[ -n $1 ]]; then
    host=$1
  else
    echo "USAGE: vm_linux {host}"
    return
  fi

  files=$(ls ${HOME}/ltm_helpers/env_files/dot*)
  files="$files ${HOME}/ltm_helpers/env_files/sudoers"

  for f in $files; do
    new=$(basename $f | sed 's/dot//')
    scp -P ${port} $f ${host}:${new}
  done
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

