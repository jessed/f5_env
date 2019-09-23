# ~/.bash_functions
# My function list is getting too involved for .bash_aliases

# update /etc/cloud/cloud.cfg to preserve hostnames
preserve_hostname() {
  sudo sed -i 's/^preserve_hostname: false/preserve_hostname: true/' /etc/cloud/cloud.cfg
}

# start the ssh-agent using whatever $SSH_AUTH_SOCK is defined
startagent() {
  if [[ -z "$SSH_AUTH_SOCK" ]]; then
    echo "ERROR: $SSH_AUTH_SOCK not defined"
    return
  else
      KEYS="id_rsa ltm_shared_key.key git_itc.key git_pkteng.key aws-te01"
    eval $(ssh-agent -a $SSH_AUTH_SOCK)
    if [ -n "$1" ]; then
      ssh-add $1
    else
      for k in $KEYS; do
        test -f ~/.ssh/${k} && ssh-add ~/.ssh/${k}
      done
    fi
  fi
}

# check the hosts file for the string
# similar to 'host' but for the hosts file
hosts() {
  if [[ -z "$1" ]]; then echo -e "\tUSAGE:  $0 <hostname>"
  else myhost=$1
  fi

  grep -E $myhost /etc/hosts

  if [[ $? -ne 0 ]]; then
    echo "$myhost not found in /etc/hosts, checking with 'host'"
    host $myhost
  fi
}

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


# List all interfaces with addresses along with the address and mac
unset -f addr
addr() {
  nics=$(ifconfig -a | awk '/^[a-z]/ { gsub(":[[:space:]]"," "); print $1}')
  match="(lo|gif|stf|pop|awdl|bridge|utun|fw|vnic)"

  for n in $nics; do
    if [[ $n =~ $match ]]; then continue
    else iface=$n
    fi
    info=$(ifconfig $iface)
    if [[ -f /etc/issue ]]; then # linux
      if [[ -f /etc/redhat-release ]]; then #Redhat
        mac=$(echo "$info" | awk '/ether /{ print $2 }')
        addr=$(echo "$info" | awk '/inet /{ print $2 }')
      else # Ubuntu
        mac=$(echo "$info" | awk '/HWaddr /{ print $5 }')
        addr=$(echo "$info" | awk '/inet addr/ { print $2 }' | sed 's/addr://')
      fi
    else # mac
      mac=$(echo "$info" | awk '/ether / { print $2}')
      addr=$(echo "$info" | awk '/inet / { print $2}')
    fi
    if [[ -n "$addr" ]]; then
      printf "%-15s %15s (%s)\n" $n $addr $mac
    fi
    unset -v iface info addr mac
  done
}


# source environment files more intelligently
src() {
  if [[ -n "$1" ]]; then
    LIST=$1
  else
    LIST="$LIST .bash_aliases .bash_functions .bash_local"
    LIST="$LIST local/remote_systems.bash"
    LIST="$LIST local/DUT_consoles.bash"
    LIST="$LIST local/DUT_mgmt.bash"
    LIST="$LIST ltm_helpers/ltm_functions.bash"
  fi

  for f in $LIST; do
    test -f ${HOME}/${f} && { echo "Sourcing ${HOME}/${f}"; source ${HOME}/${f}; }
  done
}

add_nginx() {
  cat > nginx.repo << EOF
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/mainline/centos/7/$basearch/
gpgcheck=0
enabled=1
EOF

  sudo mv nginx.repo /etc/yum.repos.d
  sudo yum update -y
  sudo yum install -y nginx
  sudo systemctl enable nginx
  sudo systemctl start nginx
}

# redefine 'exit' to be screen-friendly (new method, compatible with OS X)
exit() {
  if [[ -n "$WINDOW" ]]; then
    screen -p $WINDOW -X pow_detach
  else
    kill -1 $$
  fi
}


# count the characters in the string
count() {
  if [ -z "$1" ]; then echo "Must provide a string"; return; fi

  string=$1
  echo -n "$string" | wc -c
}

reminder() {
  if [ -z "$1" ]; then
    timer=180
  else
    if [ $1 -lt 60 ]; then
      timer=$((1*60))
    else
      timer=$1
    fi
  fi

  echo "Reminder will occur in $timer seconds"
  sleep $timer

  while [ 1 ]; do
    echo -e "\a"
    sleep 1
  done
}


clrlog() {
  if [[ -z "$1" ]]; then
    echo "USAGE: $0 <log file>"; exit 1
  else
    file=$1
  fi

  rm $file
  sudo service syslog-ng restart
}

