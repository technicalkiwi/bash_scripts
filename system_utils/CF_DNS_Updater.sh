#!/bin/bash

# CHANGE THESE
auth_email="your_login_email_here"            # The email you use to login 'https://dash.cloudflare.com'
auth_key="##############################"   # Top right corner "My profile" then "Global API Key"
zone_identifier="###########################" # Can be found in the "Overview" tab of your domain
record_name="ipv4.example.org"                     # Which record you want to be updated

# DO NOT CHANGE LINES BELOW
ip=$(curl -s https://ipv4.icanhazip.com/)

# SCRIPT START
echo "[Cloudflare DDNS] Check Initiated"

# Seek for the record
record=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records?name=$record_name" -H "X-Auth-Email: $auth_email" -H "X-Auth-Key: $auth_key" -H "Content-Type: application/json")

# Can't do anything without the record
if [[ $record == *"\"count\":0"* ]]; then
  >&2 echo -e "[Cloudflare DDNS] Record does not exist, perhaps create one first?"
  exit 1
fi

# Set existing IP address from the fetched record
old_ip=$(echo "$record" | grep -Po '(?<="content":")[^"]*' | head -1)

# Compare if they're the same
if [ $ip == $old_ip ]; then
  echo "[Cloudflare DDNS] IP has not changed."
  exit 0
fi

# Set the record identifier from result
record_identifier=$(echo "$record" | grep -Po '(?<="id":")[^"]*' | head -1)

# The execution of update
update=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records/$record_identifier" -H "X-Auth-Email: $auth_email" -H "X-Auth-Key: $auth_key" -H "Content-Type: application/json" --data "{\"id\":\"$zone_identifier\",\"type\":\"A\",\"proxied\":false,\"name\":\"$record_name\",\"content\":\"$ip\"}")

# The moment of truth
case "$update" in
*"\"success\":false"*)
  >&2 echo -e "[Cloudflare DDNS] Update failed for $record_identifier. DUMPING RESULTS:\n$update"
  exit 1;;
*)
  echo "[Cloudflare DDNS] IPv4 context '$ip4' has been synced to Cloudflare.";;
esac
