#!/bin/bash

create_serverblock () {
  {
echo server {
echo		listen 80;
echo		listen [::]:80;

echo		server_name $URI www.$URI;
echo
echo		# Proxy
echo		location /app {
echo		proxy_pass http://$IP:$PORT;
echo		include conf_files/proxy.conf;
echo	}

  echo		# logging
  echo		access_log /var/log/nginx/$URI.access.log;
   
echo }

  } >> "$URI.conf"
}



# Sets the variables
read -p "Please enter URI: " URI
read -p " Please enter Server IP: " IP
read -p " Please enter server Port: " Port

cd /etc/nginx/sites-enabled/

create_serverblock

