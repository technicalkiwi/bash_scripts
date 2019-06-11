#!/bin/bash
#script to install all the little thing on a new system

read -p "please enter username for git" $usename

read -p "please enter email for git" $email_addr

sudo add-apt-repository -y ppa:webupd8team/atom

sudo apt update -y
sudo apt upgrade -y
sudo apt autoremove

sudo apt install neofetch ssh htop chromium-browser vlc git net-tools curl wget unzip filezilla atom -y

curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg;
  sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg;
	sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list';
	sudo apt-get update;
	sudo apt-get install code;

git config --global user.name $username
git config --global user.email $email_addr
git config --sysyem core.editor nano

