#!/bin/bash

# If /root/.my.cnf exists then root password isnt needed
if [ -f /root/.my.cnf ]; then
		read -p "Please enter the NAME of the new database!: " dbname
	echo "Creating new database: $dbname"
	mysql -e "CREATE DATABASE ${dbname}"
	echo "Database successfully created!"
	echo "Showing existing databases..."
	mysql -e "show databases;"
	echo ""
		read -p "Please enter the NAME of the new database user!: " username
		read -s -p "Please enter the PASSWORD for the new database user!"  userpass
	echo "Creating new user..."
	mysql -e "CREATE USER ${username}@localhost IDENTIFIED BY '${userpass}';"
	echo "User successfully created!"
	echo ""
	echo "Granting ALL privileges on ${dbname} to ${username}!"
	mysql -e "GRANT ALL PRIVILEGES ON ${dbname}.* TO '${username}'@'localhost';"
	mysql -e "FLUSH PRIVILEGES;"
	echo "Database Creation Complete"
	exit
	
# If /root/.my.cnf doesn't exist then it will ask for root password	
else
		read  -s -p "Please enter root user MySQL password!: " rootpasswd
		read -p "Please enter the NAME of the new database!: " dbname
	echo "Creating new database..."
	mysql -uroot -p${rootpasswd} -e "CREATE DATABASE ${dbname} /*\!40100 DEFAULT CHARACTER SET ${charset} */;"
	echo "Database successfully created!"
	echo "Showing existing databases..."
	mysql -uroot -p${rootpasswd} -e "show databases;"
	echo ""
		read -p "Please enter the NAME of the new database user!: " username
		read -s -p "Please enter the PASSWORD for the new database user!"  userpass
	echo "Creating new user..."
	mysql -uroot -p${rootpasswd} -e "CREATE USER ${username}@localhost IDENTIFIED BY '${userpass}';"
	echo "User successfully created!"
	echo ""
	echo "Granting ALL privileges on ${dbname} to ${username}!"
	mysql -uroot -p${rootpasswd} -e "GRANT ALL PRIVILEGES ON ${dbname}.* TO '${username}'@'localhost';"
	mysql -uroot -p${rootpasswd} -e "FLUSH PRIVILEGES;"
	echo "Database Creation Complete"
	exit
fi