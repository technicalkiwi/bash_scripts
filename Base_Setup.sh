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
read -p "please enter username for git" $gitusername
read -p "please enter email for git" $gitemail_addr
read -p " What port do you want to use for ssh?" $SshPort

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
PACKAGES="neofetch ssh htop chromium-browser vlc software-properties-common git net-tools curl wget unzip filezilla ansible code"
install_packages


# Configure git
git config --global user.name $gitusername
git config --global user.email $gitemail_addr
git config --sysyem core.editor nano

# Pull down Auth Keys
curl https://raw.githubusercontent.com/temightyspoon/liunx-bits/master/auth_keys > /tmp/auth_tmp

# Configure sshd_config
SSHD_Path="/etc/ssh/sshd_config"
  sed -i '1 i\#Created By Base_Setup Script' "$SSHD_Path"
  sed -i "s|^\\(PermitRootLogon=\\).*|\\1no|" "$SSHD_Path"
  sed -i "s|^\\(Port=\\).*|\\1$SshPort|" "$SSHD_Path"
  sed -i "s|^\\(DB_DATABASE=\\).*|\\1$DB_NAME|" "$SSHD_Path"
  sed -i "s|^\\(DB_USERNAME=\\).*|\\1$DB_USER|" "$SSHD_Path"
  sed -i "s|^\\(DB_PASSWORD=\\).*|\\1$DB_PASS|" "$SSHD_Path"
  sed -i "s|^\\(APP_URL=\\).*|\\1http://$WEB_ADDR|" "$SSHD_Path"
