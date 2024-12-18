#!/bin/bash
set -e

echo "Setting up MariaDB..."

mysqld_safe --skip-networking &

DB_ROOT_PASS=$(cat /run/secrets/db_root_pass)
RETRY_COUNT=0
while ! mysql -u root -p"${DB_ROOT_PASS}" -e "SELECT 1"; do
	if [ $RETRY_COUNT -ge 10 ]; then
		echo "MariaDB timeout. Exiting..."
		exit 1
	fi
	echo "Waiting for MariaDB to be ready... ($RETRY_COUNT)"
	sleep 2
	RETRY_COUNT=$((RETRY_COUNT + 1))
done

mysql -u root -p"${DB_ROOT_PASS}" <<-EOSQL
	ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASS}';
EOSQL

DB_USER_NAME=$(cat /run/secrets/db_user_name)
DB_USER_PASS=$(cat /run/secrets/db_user_pass)
mysql -u root -p"${DB_ROOT_PASS}" <<-EOSQL
	CREATE DATABASE IF NOT EXISTS ${DB_NAME};
	CREATE USER IF NOT EXISTS '${DB_USER_NAME}'@'%' IDENTIFIED BY '${DB_USER_PASS}';
	GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER_NAME}'@'%';
	FLUSH PRIVILEGES;
EOSQL

echo "MariaDB setup completed successfully."

mysqladmin -u root -p"${DB_ROOT_PASS}" shutdown

exec mysqld
