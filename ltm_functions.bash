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
    echo "USAGE: ltm_env <ltm_host> [port] [user]"
    return
  fi

  if [[ -n "$2" ]]; then port=$2; else port=22; fi 
  if [[ -n $3 ]]; then user=$3; else user=root; fi

  # If not using 'root', change shell to bash
  if [[ ! $user =~ "root" ]]; then 
    echo ssh -p ${port} ${host} "modify auth user ${user} shell bash; save sys config"
    ssh -p ${port} ${host} "modify auth user ${user} shell bash; save sys config"
  fi

  # Update SCP allowed locations
  locations="/shared"
  locations="$locations\\\\n/home/${user}"
  ssh -p ${port} ${host} "echo -e $locations >> /config/ssh/scp.whitelist; tmsh restart sys service sshd"

  # copy the new environment file into place
  scp -P ${port} ${ENVFILE} ${VIMRC} ${user}@${host}:/shared
  ssh -p ${port} ${host} "ln -sf /shared/env.ltm .env.ltm; ln -sf /shared/vimrc.ltm .vimrc"
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
  #ssh -p ${port} ${host} "$cmd1 ; $cmd2 ; $cmd3 ; $cmd4 ; $cmd5 ; $cmd6"
}

# Perform initial environment customization for cloud instances
cloud_env() {
  local ENVFILE="${HOME}/f5_env/env_files/env.ltm"
  local VIMRC="${HOME}/f5_env/env_files/vimrc.ltm"

  # use admin user for all but azure
  user=admin

  if [[ -n $1 ]]; then
    host=$1
  else
    echo "USAGE: ${FUNCNAME[0]} <ltm_host> [azure|aws|gcp|other] [port]"
    return
  fi
  if [[ -n $2 ]]; then cloud=$2; else cloud=other; fi
  if [[ -n $3 ]]; then port=$3; else port=22; fi

  if [[ $cloud =~ "azure" ]]; then user=azadmin; fi
  local_ve="^ltm*|^vmltm*"
  if [[ $host =~ $local_ve ]] || [[ $host =~ $local_ve ]]; then user=root; fi

  printf 'Host: %s\nCloud: %s\nPort: %s\n\n' $host $cloud $port

	# First step: change admin user shell to bash (from tmsh)
  if [[ $user == admin ]]; then
    ssh -p ${port} ${user}@${host} "modify auth user ${user} shell bash; save sys config"
  fi

  # Update SCP allowed locations
  locations="/shared"
  locations="$locations\\\\n/home/${user}"
  ssh -p ${port} ${user}@${host} "echo -e $locations >> /config/ssh/scp.whitelist; tmsh restart sys service sshd"

  # copy the new environment file into place
  scp -P ${port} ${ENVFILE} ${VIMRC} ${user}@${host}:/shared
  #ssh -p ${port} ${user}@${host} "ln -sf /shared/env.ltm .env.ltm; ln -sf /shared/vimrc.ltm .vimrc"
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

## Update public cloud linux host environment
cloud_linux() {
  if [[ -z $1 ]]; then
    echo "USAGE: ${FUNCNAME[0]} {host} [port] (default: 22) [user] (default: admin)"
    return
  else
    host=$1
  fi
  if [[ -n $2 ]]; then port=$2; else port=22; fi
  if [[ -n $3 ]]; then user=$3; else user=admin; fi

  files=$(ls ${HOME}/f5_env/env_files/dot*)

  # Copy environment files to system with a new name (remove 'dot' from the filenames)
  for f in $files; do
    new=$(basename $f | sed 's/dot//')
    scp -P ${port} $f ${host}:${new}
  done

  cmd="touch .hushlogin"
  ssh -p ${port} ${host} "$cmd"
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
