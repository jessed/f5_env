# ltm_functions.bash
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
  local ENVFILE="${HOME}/f5_env/env_files/env.ltm"
  local VIMRC="${HOME}/f5_env/env_files/vimrc.ltm"

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
  scp -P ${port} ${ENVFILE} ${host}:/shared/env.ltm
  scp -P ${port} ${VIMRC}   ${host}:/shared/vimrc.ltm
  ssh -p ${port} ${host} "ln -sf /shared/env.ltm .env.ltm"
  ssh -p ${port} ${host} "ln -sf /shared/vimrc.ltm .vimrc"

  # update existing .bash_profile to source new environment file
  ssh -p ${port} ${host} "echo \"alias src='cd ; source /shared/env.ltm'\">> .bash_profile"
  ssh -p ${port} ${host} "echo \"source /shared/env.ltm\">> .bash_profile"

  #  don't change to the /config directory on login
  ssh -p ${port} ${host} "sed -i -e \"s/^cd \/config/#cd \/config/\" .bash_profile"

  # Run 'chk_vi_mode()' on login to set bash vi-mode
  # ssh -p ${port} root@${host} "echo -e \"\\nchk_vi_mode\">> .bash_profile"
  ssh -p ${port} ${host} "echo -e \"\\nset -o vi\">> .bash_profile"

  # comment out the 'clear' in .bash_logout
  ssh -p ${port} ${host} "sed -i -e \"s/^clear/#clear/\" .bash_logout"

  # stop printing the motd on login
  ssh -p ${port} ${host} "touch .hushlogin"

  # bind 'ctrl+l to the bash 'clear-screen' command
  ssh -p ${port} ${host} "echo 'Control-l: clear-screen' > .inputrc"

}

# Perform initial environment customization for AWS instances
cloud_env() {
  local ENVFILE="${HOME}/f5_env/env_files/env.ltm"
  local VIMRC="${HOME}/f5_env/env_files/vimrc.ltm"

  if [[ -n $1 ]]; then
    host=$1
  else
    echo "USAGE: aws_env <ltm_host> [azure|aws|gcp|other] [port]"
    return
  fi
  if [[ -n $2 ]]; then cloud=$2; else cloud=other; fi
  if [[ -n $3 ]]; then port=$2; else port=22; fi

  if [[ $cloud =~ "azure" ]]; then user=azadmin; else user=admin; fi

	# First step: change admin user shell to bash (from tmsh)
  ssh -p ${port} ${user}@${host} "modify auth user ${user} shell bash; save sys config"

  # Update SCP allowed locations
  locations="/shared"
  locations="$locations\\\\n/home/${user}"
  ssh -p ${port} ${user}@${host} "echo -e $locations >> /config/ssh/scp.whitelist; tmsh restart sys service sshd"

  # copy the new environment file into place
  scp -P ${port} ${ENVFILE} ${VIMRC} ${user}@${host}:/shared
  ssh -p ${port} ${user}@${host} "ln -sf /shared/env.ltm .env.ltm; ln -sf /shared/vimrc.ltm .vimrc"
  cmd1="ln -sf /shared/env.ltm .env.ltm; ln -sf /shared/vimrc.ltm .vimrc"

  # update existing .bash_profile and /etc/skel/.bash_profile
  strings="alias src=\'source /shared/env.ltm\'"
  strings="$strings\\\\nsource /shared/env.ltm"
  strings="$strings\\\\nset -o vi"

  cmd2="echo -e $strings >> .bash_profile"
  cmd3="echo -e $strings >> /etc/skel/.bash_profile"

  # bind 'ctrl+l to the bash 'clear-screen' command
  cmd4="echo 'Control-l: clear-screen' > .inputrc"

  # don't change to the /config directory on login
  cmd5="sed -i  's/^cd \/config/#cd \/config/' .bash_profile /etc/skel/.bash_profile"

  # comment out the 'clear' in .bash_logout
  #ssh -p ${port} ${user}@${host} "sed -i -e \"s/^clear/#clear/\" .bash_logout"
  cmd6="sed -i  's/^clear/#clear/' .bash_logout"

  # run all commands with a single SSH command
  ssh -p ${port} ${user}@${host} "$cmd1 ; $cmd2 ; $cmd3 ; $cmd4 ; $cmd5 ; $cmd6"
}


azure_env() {
  local ENVFILE="${HOME}/f5_env/env_files/env.ltm"
  local VIMRC="${HOME}/f5_env/env_files/vimrc.ltm"

  if [[ -n "$1" ]]; then
    host=$1
  else
    echo "USAGE: $0 <ltm_host> [user]"
    return
  fi
  if [[ -n $2 ]]; then user=$2; else user=azadmin; fi
  if [[ -n $3 ]]; then port=$3; else port=22; fi

	# First step: change admin user shell to bash (from tmsh)
	ssh -p ${port} ${user}@${host} "modify auth user ${user} shell bash; save sys config"
  ssh -p ${port} ${user}@${host} "echo /shared >> /config/ssh/scp.whitelist"
  ssh -p ${port} ${user}@${host} "echo /home/${user} >> /config/ssh/scp.whitelist"
  ssh -p ${port} ${user}@${host} "tmsh restart sys service sshd"

  # copy the new environment file into place
  scp -P ${port} ${ENVFILE} ${user}@${host}:/shared/env.ltm
  scp -P ${port} ${VIMRC}   ${user}@${host}:/shared/vimrc.ltm
  ssh -p ${port} ${user}@${host} "ln -sf /shared/env.ltm .env.ltm"
  ssh -p ${port} ${user}@${host} "ln -sf /shared/vimrc.ltm .vimrc"

  # update existing .bash_profile to source new environment file
  ssh -p ${port} ${user}@${host} "echo \"alias src='source /shared/env.ltm'\">> .bash_profile"
  ssh -p ${port} ${user}@${host} "echo \"source /shared/env.ltm\">> .bash_profile"

  #  don't change to the /config directory on login
  ssh -p ${port} ${user}@${host} "sed -i -e \"s/^cd \/config/#cd \/config/\" .bash_profile"

  # Run 'chk_vi_mode()' on login to set bash vi-mode
  #ssh -p ${port} ${user}@${host} "echo -e \"\\nchk_vi_mode\">> .bash_profile"
  ssh -p ${port} ${user}@${host} "echo -e \"\\nset -o vi\">> .bash_profile"


  # comment out the 'clear' in .bash_logout
  ssh -p ${port} ${user}@${host} "sed -i -e \"s/^clear/#clear/\" .bash_logout"

  # Add .bash_profile changes to /etc/skel/.bash_profile to persist across re-instantiations
  ssh -p ${port} ${user}@${host} "echo -e \"\\n\\nalias src='source /shared/env.ltm'\">> /etc/skel/.bash_profile"
  ssh -p ${port} ${user}@${host} "echo \"source /shared/env.ltm\">> /etc/skel/.bash_profile"
  ssh -p ${port} ${user}@${host} "sed -i -e \"s/^cd \/config/#cd \/config/\" /etc/skel/.bash_profile"
  ssh -p ${port} ${user}@${host} "echo -e \"\\nset -o vi\">> /etc/skel/.bash_profile"

  # stop printing the motd on login
  #ssh ${user}@${host} "touch .hushlogin"

  # bind 'ctrl+l to the bash 'clear-screen' command
  #ssh -p ${port} ${user}@${host} "echo 'Control-l: clear-screen' > .inputrc"
}

## Update AWS linux host environment
cloud_linux() {
  if [[ -z "$1" ]]; then
    echo "USAGE: ${FUNCNAME[0]} {host} [port] (default: 22) [user] (default: admin)"
    return
  else
    host=$1
  fi

  if [[ -n "$2" ]]; then
    port=$2
  else
    port=22
  fi
  if [[ -n $3 ]]; then
    user=$3
  else
    user=admin
  fi

  files=$(ls ${HOME}/f5_env/env_files/dot*)
  files="$files ${HOME}/f5_env/env_files/sudoers"
  #files="$files ${HOME}/f5_env/env_files/nginx.repo"

  for f in $files; do
    new=$(basename $f | sed 's/dot//')
    scp -P ${port} $f ${host}:${new}
  done

  ssh -p ${port} ${host} 'sudo chmod 440 sudoers'
  ssh -p ${port} ${host} 'sudo chown root.root sudoers'
  #ssh -p ${port} ${host} "sudo sed -i -e 's/ - set_hostname/# - set_hostname/' /etc/cloud/cloud.cfg"
  ssh -p ${port} ${host} "sudo sed -i -e 's/preserve_hostname: false/preserve_hostname: true/' /etc/cloud/cloud.cfg"
  #ssh -p ${port} ${host} 'test -d /etc/sysconfig/network-scripts && ln -s /etc/sysconfig/network-scripts/'
  #ssh -p ${port} ${host} 'test -d /etc/netplan && ln -s /etc/netplan/'
  ssh -p ${port} ${host} 'sudo mv sudoers /etc'
  ssh -p ${port} ${host} 'touch ~/.hushlogin'
}

## Update local linux VM host environment
vm_linux() {
  if [[ -n $1 ]]; then
    host=$1
  else
    echo "USAGE: vm_linux {host} [port]"
    return
  fi
  
  if [[ -n $2 ]]; then port=$2
  else                 port=22
  fi

  files=$(ls ${HOME}/f5_env/env_files/dot*)
  files="$files ${HOME}/f5_env/env_files/sudoers"

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



strip_regkeys() {
  awk '/^Registration/ { print $4 }' $1
  echo -e "\n"
  tail -6 $1
}
