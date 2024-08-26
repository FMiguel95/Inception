#!/bin/bash

service mariadb start

echo "Setting up MariaDB..."

mysql -u root -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
mysql -u root -e "CREATE USER IF NOT EXISTS '$DB_USER_NAME'@'%' IDENTIFIED BY '$DB_USER_PASS';"
mysql -u root -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER_NAME'@'%' IDENTIFIED BY '$DB_USER_PASS';"
mysql -u root -e "FLUSH PRIVILEGES;"

echo "MariaDB setup completed successfully."

service mariadb stop

exec "$@"
