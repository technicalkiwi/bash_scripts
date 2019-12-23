#!/bin/bash

#Setup Log Command
log () {
  if [ -n "$verbose" ]; then
    eval "$@" |& tee -a /var/log/docker_install.log
  else
    eval "$@" |& tee -a /var/log/docker_install.log >/dev/null 2>&1
  fi
}

#Setup Install Packages Command
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


# Update Apt cache
sudo apt update

# Installs needed packages
PACKAGES="apt-transport-https ca-certificates curl software-properties-common gnupg-agent" 
install_packages

# Pulls key and adds docker repo
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Updates apt repo and installs docker CE
sudo apt update
sudo apt install docker-ce -y
sudo usermod -aG docker $USER
clear

# Displays docker version 
docker -v

# wWits for key press before running hello-world
read -n 1 -s -r -p "Press any key to run your first docker"
sudo docker container run hello-world

# Install Docker Compose

sudo apt install docker-compose -y