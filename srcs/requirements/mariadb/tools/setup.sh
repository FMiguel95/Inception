#!/bin/bash
set -e

echo "Setting up MariaDB..."

# Start MariaDB in safe mode without networking to allow for initialization
mysqld_safe --skip-networking &

echo "Waiting for MariaDB to start..."
sleep 5
while ! mysql -u root -e "SELECT 1"; do
	echo "Waiting for MariaDB to start..."
	sleep 5
done

# Set up the database and user
DB_USER_PASS=$(cat /run/secrets/db_user_pass)
mysql -u root <<-EOSQL
	CREATE DATABASE IF NOT EXISTS ${DB_NAME};
	CREATE USER IF NOT EXISTS '${DB_USER_NAME}'@'%' IDENTIFIED BY '${DB_USER_PASS}';
	GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER_NAME}'@'%';
	FLUSH PRIVILEGES;
EOSQL

echo "MariaDB setup completed successfully."

# Stop the safe mode MariaDB instance
mysqladmin -u root shutdown

# Start MariaDB normally, replacing the current shell process with the mysqld process
exec mysqld
