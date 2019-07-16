#!/bin/bash

create_serverblock () {
  {
echo server {
echo		listen 80\;
echo		listen [::]:80\;

echo		server_name $URI www.$URI\;
echo
echo		# Proxy
echo		location /app {
echo		proxy_pass http://$IP:$PORT\;
echo		include conf_files/proxy.conf\;
echo	}

  echo		# logging
  echo		access_log /var/log/nginx/$URI.access.log\;
   
echo }

  } >> "$URI.conf"
}

create_sslserverblock() {
    {
        echo server { 
        echo        listen 443 ssl\;
        echo        listen [::]:443\;

        echo        server_name $URI www.$URI\;
        echo        
        echo         #SSL
        echo        ssl_certificate /etc/letsencrypt/live/$URI/fullchain.pem\;
        echo        ssl_certificate_key /etc/letsencrypt/live/$URI/privkey.pem\;
        echo        ssl_trusted_certificate /etc/letsencrypt/live/$URI/chain.pem\;
        echo
        echo
        echo        # Logging
        echo        access_log /var/log/nginx/$URI.access.log\;

        echo        #Reverse Proxy
        echo        location / {
        echo        proxy_pass http://$IP:$PORT\;
        echo        include conf_files/proxy.conf\;
        echo }
echo }
        echo
        echo        #HTTP Redirect
        echo    server {
        echo            listen 80\;
        echo            listen [::]:80\;

        echo            server_name $URI www.$URI\;
        echo
        echo            location / {
        echo            return 301 https://$URI$request_uri\;
        echo }
echo }
    } >>$URI.conf
}


# Sets the variables
read -p "Please enter URI: " URI
read -p " Please enter Server IP: " IP
read -p " Please enter server Port: " PORT

cd /etc/nginx/sites-enabled/

rm $URI.conf

create_serverblock

certbot certonly --nginx -d $URI -d www.$URI

rm $URI.conf

create_sslserverblock

