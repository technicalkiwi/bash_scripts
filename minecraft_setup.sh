#!/bin/bash
#Script to install Minecraft server

log () {
  if [ -n "$verbose" ]; then
    eval "$@" |& tee -a /var/log/minecraft_setup.log
  else
    eval "$@" |& tee -a /var/log/minecraft_setup.log >/dev/null 2>&1
  fi
}

create_start.sh(){
 {echo "#!/bin/bash"
 echo ""
 echo "java -Xms1024M -Xmx1024M -jar server.jar "
} >> start.sh
}


sudo apt update && sudo apt upgrade -y

sudo apt install openjdk-8-jre-headless screen

sudo useradd -G sudo  minecraft 
sudo mkdir /home/minecraft/server

cd /home/minecraft/server 
wget https://launcher.mojang.com/v1/objects/d0d0fe2b1dc6ab4c65554cb734270872b72dadd6/server.jar


create_start.sh

sudo chmod +x start.sh
log ./start.sh

sed -i "s|^\\(eula=\\).*|\\1"true"|" "eula.txt"