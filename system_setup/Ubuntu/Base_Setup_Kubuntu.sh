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




# Set Variables for script
read -p "Please Enter Username for git:  " $gitusername
read -p "Please EnterDemail for git:  " $gitemail_addr
read -p "Plesae Enter Port to use for ssh:  " $SshPort

sudo apt update -y
sudo apt upgrade -y
sudo apt autoremove -y

# Install Package
#Add in Repos
sudo apt-add-repository --yes --update ppa:ansible/ansible
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg;
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg;
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list';

#Start package installation
apt update
PACKAGES="neofetch ssh htop chromium-browser vlc software-properties-common flameshot git net-tools curl wget unzip filezilla ansible code g++ libx11-dev libxext-dev qtbase5-dev libqt5svg5-dev libqt5x11extras5-dev libkf5windowsystem-dev qttools5-dev-tools cmake checkinstall"
install_packages

# Install Kvantum 
cd /tmp 
wget https://github.com/tsujan/Kvantum/archive/master.zip
unzip master.zip
cd Kvantum-master
cd Kvantum
mkdir build && cd build
cmake ..
make
sudo make install

# Move back to tmp
cd /tmp

# Configure git
git config --global user.name $gitusername
git config --global user.email $gitemail_addr
git config --sysyem core.editor nano

# Pull down Auth Keys and add them in
curl https://raw.githubusercontent.com/technicalkiwi/Liunx_bits/master/auth_keys > /tmp/auth_tmp
mkdir -p ~/.ssh && cp /tmp/auth_tmp ~/.ssh/authorized_keys


# Configure sshd_config
#SSHD_Path="/etc/ssh/sshd_config"
#  sed -i '1 i\#Created By Base_Setup Script' "$SSHD_Path"
#  sed -i "s|^\\(PermitRootLogon=\\).*|\\1no|" "$SSHD_Path"
#  sed -i "s|^\\(Port=\\).*|\\1$SshPort|" "$SSHD_Path"
#  sed -i "s|^\\(DB_DATABASE=\\).*|\\1$DB_NAME|" "$SSHD_Path"
#  sed -i "s|^\\(DB_USERNAME=\\).*|\\1$DB_USER|" "$SSHD_Path"
#  sed -i "s|^\\(DB_PASSWORD=\\).*|\\1$DB_PASS|" "$SSHD_Path"
#  sed -i "s|^\\(APP_URL=\\).*|\\1http://$WEB_ADDR|" "$SSHD_Path"
