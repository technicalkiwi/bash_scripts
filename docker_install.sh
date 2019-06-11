#!/bin/bash
sudo apt update

#installs needed commands
sudo apt install apt-transport-https ca-certificates curl software-properties-common

#pulls key and adds docker repo
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

#updates apt repo and installs docker CE
sudo apt update
sudo apt install docker-ce -y
sudo usermod -aG docker $USER
clear

#displays docker version 
docker -v

#waits for key press before running hello-world
read -n 1 -s -r -p "Press any key to run your first docker"
sudo docker container run hello-world
