#!/bin/bash
set -e

echo "Setting up MariaDB..."

# Start MariaDB in safe mode without networking to allow for initialization
mysqld_safe --skip-networking &

# Wait for MariaDB to be ready
while true; do
	echo "Waiting for MariaDB to start..."
	sleep 5
	if mysql -u root -e "SELECT 1"; then
		break
	fi
done

# Set up the database and user
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
