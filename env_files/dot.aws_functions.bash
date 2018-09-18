# ~/.aws_functions.bash
# Bash functions specific to linux instances running Oslo in AWS


# Enabled Bash VI-mode if $VIMODE=1 (sent as SSH env variable)
chk_vi_mode() {
  if [ -n "$VIMODE" ]; then
    if [ $VIMODE -eq 1 ]; then
      set -o vi
    fi
  fi
}

# Add ens4 to /etc/network/interfaces.d/50-cloud-init.cfg and bring it up
enable_datanic() {
  status=$(ip link show ens4 up)

  if [[ -z "$status" ]]; then
    echo -e "\n\niface ens4 inet manual" >> /etc/network/interfaces.d/50-cloud-init.cfg
    ifup ens4
  else
    #echo "ens4 already enabled"
    return
  fi
}

# Run enable_datanic() with sudo
start_datanic() {
  sudo bash -c "$(declare -f enable_datanic); enable_datanic"
}


# Update the hostname in /etc/hostname
update_hostname() {
  #addr=$(hostname -I)
  #awk /$addr/'{print $2}' /etc/hosts > /etc/hostname

  addr=$(cat /etc/hostname | sed 's/-/./g' | sed 's/ip.//')
  awk /$addr/'{print $2}' /etc/hosts > /etc/hostname
  hostname -F /etc/hostname
}

# Set the new hostname
set_hostname() {
  sudo bash -c "$(declare -f update_hostname); update_hostname"
}
