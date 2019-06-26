#!/bin/bash
PROGRAM =""

log () {
  if [ -n "$verbose" ]; then
    eval "$@" |& tee -a /var/log/$PROGRAM-install.log
  else
    eval "$@" |& tee -a /var/log/$PROGRAM-install.log >/dev/null 2>&1
  fi
}

install_packages () {
        for p in $PACKAGES; do
        if dpkg -s "$p" >/dev/null 2>&1; then
          echo "  * $p already installed"
        else
echo "  * Installing $p"
log "apt-get install -y $p"
 fi
done;
       }


#Install Packages
sudo apt update && sudo apt upgrade -y

PACKAGES=""
install_packages

