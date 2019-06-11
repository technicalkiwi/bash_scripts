#!/bin/bash
#script to remove all the bloatware that comes preinstalled on Rasbian.

apt update
apt purge libreoffice* wolfram* minecraft-pi sonic-pi scratch nuscratch idle3 smartsim  java-common python-minecraftpi python3-minecraftpi bluej nodered claws-mail claws-mail-i18n python-pygame --purge -y
apt clean
apt autoremove --purge -y
apt update
apt upgrade -y
apt autoremove -y
