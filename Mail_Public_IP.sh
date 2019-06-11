#!/bin/bash
IPFILE="~/bin/ip/current.ip"
CURRENTIP=$(dig +short myip.opendns.com @resolver1.opendns.com)
LOG="~/bin/ip/ip.log"

KNOWN_IP=$(cat $IPFILE)

#Test line to check it was pulling in the IP from file correctly
#echo $KNOWN_IP >  ~/bin/ip/test.ip

if [ "$CURRENTIP" = "$KNOWN_IP" ]; then
logger -t ext_ipcheck -- NO IP Change
else
echo $CURRENTIP > $IPFILE
mail -s "NEW IP" mail@mail.com < $IPFILE
logger -t ext_ipcheck -- IP changed to $CURRENTIP
fi
