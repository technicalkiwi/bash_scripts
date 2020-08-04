## Setup Commands


read -p "Please Enter NetAdapter to Change (eht16): " $NETADAPTER 
read -p "Please Enter IP Address for Server: " $IPADDR
NETFILE = "/etc/sysconf ig/network-scripts/ifcfg-$NETADAPTER


sed 's/ONBOOT="no"/ONBOOT="yes"/g'
echo "IPADDR=$IPADDR" >> $Netfile
echo "NETMASK=255.255.252.0" >> $Netfile
echo "GATEWAY=192.168.10.254" >> $Netfile
echo "DNS1=192.168.10.80" >> $Netfile
echo "DNS2=192.168.10.81" >> $Netfile

/etc/sysconf ig/network-scripts/ifcfg-