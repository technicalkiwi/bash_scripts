#!/bin/bash
#script to install the LEMP Stack
#Uses MariaDB rather than MYSQL

sudo apt update 

#installs the stack
sudo apt install nginx mariadb-server mariadb-client php php-fpm php-mysql php-cli php-curl php-gd wget git unzip

#enables the webserver on startup
sudo systemctl enable nginx

#starts the webserver
sudo systemctl start nginx

#allows webserver through firewall
sudo ufw allow 'Nginx HTTP'

#access permssions to webserver folders
sudo chmod -R 755 /var/www/html/*

#creates a PHP test page in webserver folder
sudo echo "<?php phpinfo(); ?>" > /var/www/html/info.php
sudo chmod -R 755 /var/www/html/*

#optional- Install phpmyadmin
sudo apt install phpmyadmin php-mbstring php-gettext

#optional - Install Certbot
sudo apt-get install -y software-properties-common
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install python-certbot-nginx
sudo ufw allow 'Nginx Full'
sudo ufw delete allow 'Nginx HTTP'
