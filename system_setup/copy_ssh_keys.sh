#!/bin/bash

# This script will copy public keys from git hub and add them to the allowed_keys file

curl https://raw.githubusercontent.com/technicalkiwi/Linux_bits/master/auth_keys > /tmp/auth_tmp
mkdir -p ~/.ssh && cp /tmp/auth_tmp ~/.ssh/authorized_keys
