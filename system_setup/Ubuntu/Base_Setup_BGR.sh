#!/bin/bash
#script to install all the little thing on a new system

#Setup Log Command
log () {
  if [ -n "$verbose" ]; then
    eval "$@" |& tee -a /var/log/base_setup.log
  else
    eval "$@" |& tee -a /var/log/base_setup.log >/dev/null 2>&1
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



#Add in Proxy Settings
sudo rm /etc/apt/apt.conf.d/proxy.conf
sudo touch /etc/apt/apt.conf.d/proxy.conf
echo 'Acquire::http::Proxy "http://192.168.10.206:3980/";' >> /etc/apt/apt.conf.d/proxy.conf
echo 'Acquire::https::Proxy "https://192.168.10.206:3980/";' >> /etc/apt/apt.conf.d/proxy.conf


sudo apt update -y
sudo apt upgrade -y
sudo apt autoremove -y

sleep 10

# Install Package
#Add in Repos
sudo apt-add-repository --yes --update ppa:ansible/ansible

#Start package installation
apt update
PACKAGES="neofetch ssh htop chromium-browser vlc software-properties-common flameshot git net-tools curl wget unzip filezilla ansible g++ libx11-dev libxext-dev qtbase5-dev libqt5svg5-dev libqt5x11extras5-dev libkf5windowsystem-dev qttools5-dev-tools cmake checkinstall"
install_packages

