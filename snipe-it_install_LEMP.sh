#!/bin/bash
#script to install Snipe-IT Asset Management 

apt update 

#installs Basic LEMP stack
apt install nginx mariadb-server mariadb-client php -php php-cli curl git unzip -y

#installs needed PHP addons
apt install php-mcrypt php-curl php-mysql php-gd php-ldap php-zip php-mbstring php-xml php-bcmath php-cli -y

#enable webserver on startup
systemctl start mariadb.service

readonly APP_USER="snipeit_user"
readonly APP_NAME="snipe-it"
readonly APP_PATH="/var/www/$APP_NAME"

#DATABASE CREATION
  echo "Please enter root user MySQL password!"
  read rootpasswd
mysql -uroot -p${rootpasswd} -e "CREATE DATABASE snipeit_db;"
mysql -uroot -p${rootpasswd} -e "show databases;"
	echo "Please enter a PASSWORD to be used for the snipeit database user!"
	read userpass
mysql -uroot -p${rootpasswd} -e "GRANT ALL PRIVILEGES ON snipeit_db.* TO '$snipeit_user'@'localhost' IDENTIFIED BY '${userpass}';"
mysql -uroot -p${rootpasswd} -e "FLUSH PRIVILEGES;"
  echo "Database Creation Complete"
  echo " Database Name:	 snipeitapp"
  echo " Username:	 snipeit_user"


#Install composer - A dependancy manager for PHP
cd /tmp
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer


#clones from repository
git clone https://github.com/snipe/snipe-it $APP_PATH

#adds ther snipeitapp user
adduser --quiet --disabled-password --gecos '""' "$APP_USER"

chmod -R 775 "$APP_PATH/storage"
chmod -R 755 "$APP_PATH/public/uploads"

#grants permssions to snipeitapp user
chown -R "$APP_USER":"" "$APP_PATH"

#setup .env file
cd /var/www/snipe-it/snipe-it
$ sudo mv .env.example .env

phpenmod mcrypt
phpenmod mbstring
a2enmod rewrite
#$APP_NAME.conf
