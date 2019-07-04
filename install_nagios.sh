#!/bin/bash
PROGRAM ="nagios"
#update this with latest Links from https://www.nagios.org/downloads/nagios-core/thanks/?skip=1&product_download=nagioscore-source
NAGIOS_CORE_URL="https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.4.3.tar.gz"
NAGIOS_PLUGINS_URL="https://nagios-plugins.org/download/nagios-plugins-2.2.1.tar.gz"

log () {
  if [ -n "$verbose" ]; then
    eval "$@" |& tee -a /var/log/$PROGRAM-install.log
  else
    eval "$@" |& tee -a /var/log/$PROGRAM-install.log >/dev/null 2>&1
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


#Install Packages
sudo apt update && sudo apt upgrade -y

PACKAGES=" httpd mariadb-server php php-mysql gcc glibc glibc-common wget gd gd-devel perl postfix make gettext automake autoconf openssl-devel net-snmp net-snmp-utils epel-release perl-Net-SNMP"
install_packages

#enable webserver on startup
systemctl start mariadb.service
systemctl start apache2.service

#secure mariadb install
/usr/bin/mysql_secure_installation

#Download Nagios
cd /tmp
wget $NAGIOS_CORE_URL
tar xzf nagioscore*.tar.gz

#Install Nagios
cd /tmp/nagiosco*
./configure
make all
make install-groups-users
usermod -a -G nagios apache
make install

#Run Initialization Scripts
make install-daemoninit
make install-config
make install-commandmode
make install-webconf

#Restat Apache Service
systemctl restart httpd

#create Nagios Admin Account
htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin

#Download Plugins
cd /tmp
wget $NAGIOS_PLUGINS_URL
tar zxf nagios-plugins*.tar.gz

#Install Plugins
cd /tmp/nagios-plugins*
./configure
make
make install

#Start Nagios Core
systemctl start nagios

#Open Firewall port
ufw allow http
ufw allow https

# To access Nagios Core, open your browser and navigate to http://YOUR-IP-ADDRESS/nagios 
# and log in using the nagiosadmin user account you created in the previous steps
