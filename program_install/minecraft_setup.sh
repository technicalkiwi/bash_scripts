#!/bin/bash
#Script to install Minecraft server

JARFILE = "https://launcher.mojang.com/v1/objects/d0d0fe2b1dc6ab4c65554cb734270872b72dadd6/server.jar"

# create logging function
log () {
  if [ -n "$verbose" ]; then
    eval "$@" |& tee -a /var/log/minecraft_setup.log
  else
    eval "$@" |& tee -a /var/log/minecraft_setup.log >/dev/null 2>&1
  fi
}

# function to create server_start.sh
create_start.sh(){
{ echo "#!/bin/bash"
  echo ""
  echo "java -Xms1024M -Xmx1024M -jar server.jar nogui"
} >> server_start.sh
}

# function to create server_run.sh
create_run.sh(){
{ echo "#!/bin/bash"
  echo ""
  echo "screen -dmS Minecraft /home/minecraft/server/server_start.sh bash
  } >> server_run.sh
}

#

# update and upgrade apt
sudo apt update && sudo apt upgrade -y
sudo apt install wget unzip openjdk-8-jre-headless screen -y

# create user to run server
sudo useradd -G sudo  minecraft 
sudo mkdir -p /home/minecraft/server

# download server jar file
cd /home/minecraft/server 
wget $JARFILE

# create startup script
create_start.sh
sudo chmod +x server_start.sh
log ./server_start.sh

#alter eula to be true
sed -i "s|^\\(eula=\\).*|\\1"true"|" "eula.txt"

# create Run script
create_run.sh
sudo chmod +x server_run.sh
