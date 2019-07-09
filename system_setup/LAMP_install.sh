#!/bin/bash
#script to install the LAMP Stack
#Uses MariaDB rather than MYSQL

sudo apt update 

#installs the stack
sudo apt install apache2 mariadb-server php php-mysql libapache2-mod-php php-cli
sudo a2enmod rewrite

#enables the webserver on startup
sudo systemctl enable apache2

#starts the webserver
sudo systemctl start apache2

#allows webserver through firewall
sudo ufw allow in "Apache Full"

#access permssions to webserver folders
sudo chmod -R 0755 /var/www/html/

#creates a PHP test page in webserver folder
sudo echo "<?php phpinfo(); ?>" > /var/www/html/info.php

#optional- Install phpmyadmin
sudo apt install phpmyadmin php-mbstring php-gettext
sudo php5enmod mcrypt

sudo service apache2 restart

#takes ownership of files
sudo chown root:root /etc/phpmyadmin/ -R
sudo chown root:www-data /etc/phpmyadmin/config-db.php
sudo chown root:www-data /etc/phpmyadmin/htpasswd.setup

#links files to make editing config easier
sudo ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf.d/phpmyadmin.conf
sudo /etc/init.d/apache2 reload
sudo ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf-enabled/phpmyadmin.conf
sudo /etc/init.d/apache2 reload
sudo service apache2 restart
clear
