#!/bin/bash
#script to install Snipe-IT Asset Management 

log () {
  if [ -n "$verbose" ]; then
    eval "$@" |& tee -a /var/log/snipeit-install.log
  else
    eval "$@" |& tee -a /var/log/snipeit-install.log >/dev/null 2>&1
  fi
}

install_packages () {
        for p in $PACKAGES; do
        if dpkg -s "$p" >/dev/null 2>&1; then
          echo "  * $p already installed"
        else
echo "  * Installing $p"
log "apt-get install -y $p"
 fi
done;
       }


  create_serverblock () {
  {
echo server {
echo		listen 80\;
echo		listen [::]:80\;

echo		server_name $WEB_ADDR www.$WEB_ADDR\;
echo    root $APP_PATH/public\;
echo
echo    \# Proxy Config
echo    include conf_files/proxy.conf\;
echo
echo    \# Iframe Config
echo    include conf_files/iframe.conf\;
echo	
echo     location ~ /.well-known {
echo        allow all\;
echo    }

echo	}

  echo		# logging
  echo		access_log /var/log/nginx/$WEB_ADDR.access.log\;
   
echo } >> "$nginxfile"
}

create_virtualhost () {
  {
    echo "<VirtualHost *:80>"
    echo "  <Directory $APP_PATH/public>"
    echo "      Allow From All"
    echo "      AllowOverride All"
    echo "      Options -Indexes"
    echo "  </Directory>"
    echo ""
    echo "  DocumentRoot $APP_PATH/public"
    echo "  ServerName $WEB_ADDR"
    echo "</VirtualHost>"
  } >> 

#updates and upgrades installed apps
log "apt update && apt upgrade -y" 

PACKAGES="mariadb-server mariadb-client nginx php php-mcrypt php-curl php-mysql php-gd php-ldap php-zip php-mbstring php-xml php-bcmath curl git unzip"
install_packages

#enable webserver on startup
systemctl start mariadb.service

#secure mariadb install
/usr/bin/mysql_secure_installation

#set variables for user, app name and path,
readonly APP_USER="snipeit_user"
readonly APP_NAME="snipe-it"
readonly APP_PATH="/var/www/$APP_NAME"

#DATABASE VARIABLE INPUT
	read -p "Please enter a Database name [snipeit_db]: " DB_NAME
  DB_NAME=${DB_NAME:-snipeit_db}
  read -p "Please enter a Database user [snipeit_user]: " DB_USER
  DB_USER=${DB_USER:-snipeit_user}
  read -p "Please enter a PASSWORD to be used for the snipeit database user!: " DB_PASS
  read -s -p "Please enter root user MySQL password!: " rootpasswd

#DATABASE VARIABLE INPUT
  mysql -uroot -p${rootpasswd} -e "CREATE DATABASE ${DB_NAME};"
  mysql -uroot -p${rootpasswd} -e "show databases;"
  mysql -uroot -p${rootpasswd} -e "GRANT ALL PRIVILEGES ON snipeit_db.* TO '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';"
  mysql -uroot -p${rootpasswd} -e "FLUSH PRIVILEGES;"
  echo "Database Creation Complete"
  echo " Database Name:	 ${DB_NAME}"
  echo " Username:    	 ${DB_USER}"


#clones from repository
  git clone https://github.com/snipe/snipe-it $APP_PATH
  
#Install composer - A dependancy manager for PHP
  cd /tmp
  curl -sS https://getcomposer.org/installer | php
  mv composer.phar /usr/local/bin/composer

#adds ther snipeitapp user and sets permission levels
  adduser --quiet --disabled-password --gecos '""' "$APP_USER"
  chmod -R 775 "$APP_PATH/storage"
  chmod -R 755 "$APP_PATH/public/uploads"

#grants permssions to snipeitapp user
#chown -R "$APP_USER":"$apache_group" "$APP_PATH"
#setup .env file
cd /var/www/snipe-it
$ sudo cp .env.example .env

#Set needed variable in .env file
tzone=$(cat /etc/timezone)
read -p "Please enter the URL for site [localhost]: " WEB_ADDR
 WEB_ADDR=${WEB_ADDR:-localhost}

  sed -i '1 i\#Created By Snipe-it Installer' "$APP_PATH/.env"
  sed -i "s|^\\(APP_TIMEZONE=\\).*|\\1$tzone|" "$APP_PATH/.env"
  sed -i "s|^\\(DB_HOST=\\).*|\\1$localhost|" "$APP_PATH/.env"
  sed -i "s|^\\(DB_DATABASE=\\).*|\\1$DB_NAME|" "$APP_PATH/.env"
  sed -i "s|^\\(DB_USERNAME=\\).*|\\1$DB_USER|" "$APP_PATH/.env"
  sed -i "s|^\\(DB_PASSWORD=\\).*|\\1$DB_PASS|" "$APP_PATH/.env"
  sed -i "s|^\\(APP_URL=\\).*|\\1http://$WEB_ADDR|" "$APP_PATH/.env"

#Create nginx server block
nginxfile=/etc/nginx/sites-available/$WEB_ADDR.conf
create_serverblock

echo "* Running composer."
/usr/local/bin/composer install --no-dev --prefer-source --working-dir "$APP_PATH"

echo "* Generating the application key."
  log "php $APP_PATH/artisan key:generate --force"

echo "* Artisan Migrate."
  log "php $APP_PATH/artisan migrate --force"

phpenmod mbstring
$APP_NAME.conf

echo "* Restarting Apache httpd."
log "systemctl restart apache2"
