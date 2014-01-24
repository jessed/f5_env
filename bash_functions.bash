# add RSA key to ssh-agent
addkey() {
  if [ -z "$1" ]; then
    test -f ~/.ssh/id_rsa && ssh-add ~/.ssh/id_rsa
    test -f ~/.ssh/ltm_shared_key.key && ssh-add ~/.ssh/ltm_shared_key.key
    test -f ~/.ssh/git_itc.key && ssh-add ~/.ssh/git_itc.key
  else
    ssh-add $1
  fi
}

# start the ssh-agent using whatever $SSH_AUTH_SOCK is defined
startagent() {
  if [[ -z "$SSH_AUTH_SOCK" ]]; then
    echo "ERROR: $SSH_AUTH_SOCK not defined"
    echo "Specify it manually in .profile or .bashrc to ensure"
    echo "that all of your shells use the same one."
    return
  else
    eval $(ssh-agent -a $SSH_AUTH_SOCK)
    # see function above
    addkey
  fi
}

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
  echo "Sending $KEY to $HOST for $USER"
  echo "ssh ${USER}@${HOST} \"echo $(< $KEY) >> ~/.ssh/authorized_keys\""
  ssh ${USER}@${HOST} "echo $(< $KEY) >> ~/.ssh/authorized_keys"
}

# Takes several steps to prepare the remote host environment.
# Most of the changes are not enabled until you enter the 'src'
# command, which sources the ~/.env.ltm
# SYNTAX:  ltm_env <host>
ltm_env() {
  if [[ -z "$1" ]]; then
    echo "USAGE: ltm_env <ltm_host> [env file]"
    return
  else
    host=$1
  fi

  if [[ -z "$2" ]]; then
    local ENVFILE="${HOME}/misc/env.ltm"
  else
    local ENVFILE=$2
  fi

  # copy the new environment file into place
  scp ${ENVFILE} root@${host}:.env.ltm

  # update existing .bash_profile to source new environment file
  ssh root@${host} "echo \"alias src='cd ;. ~/.env.ltm'\">> .bash_profile"

  # stop printing the motd on login
  ssh root@${host} "touch .hushlogin"

  # comment out the 'clear' in .bash_logout
  ssh root@${host} "sed -i -e \"s/^clear/#clear/\" .bash_logout"
}

# monitor a host and alert when the system starts responding to pings
# doesn't initialize the notification until after the system stops responding
watchhost() {
  go=1
  while [ $go -eq 1 ]; do
    ping -c1 -W 1 $1 >/dev/null 2>&1
    if [ $? -eq 0 ]; then
      #echo "ping succeeded, sleeping"
      sleep 1
    else
      #echo "ping failed, setting go = 0"
      echo "No echo response, entering notification phase"
      go=0
      sleep 1
    fi
  done

  while [ 1 ]; do
    ping -c1 $1 >/dev/null 2>&1
    if [ $? -ne 0 ]; then
      sleep 1
    else
      echo -e "$1 is up\a"
      sleep 1
    fi
  done
}

# flash the screen after the given number of seconds (as a reminder)
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

