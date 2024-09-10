#!/bin/bash
set -e

echo "Setting up MariaDB..."

# Ensure socket directory exists
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# Start MariaDB in safe mode without networking to allow for initialization
mysqld_safe --skip-networking --socket=/var/run/mysqld/mysqld.sock &

# Wait for MariaDB to be ready
sleep 5  # give MariaDB time to initialize

until mysql -u root --socket=/var/run/mysqld/mysqld.sock -e "SELECT 1"; do
  echo "Waiting for MariaDB to start..."
  sleep 2
done

# Set up the database and user
mysql -u root --socket=/var/run/mysqld/mysqld.sock <<-EOSQL
    CREATE DATABASE IF NOT EXISTS ${DB_NAME};
    CREATE USER IF NOT EXISTS '${DB_USER_NAME}'@'%' IDENTIFIED BY '${DB_USER_PASS}';
    GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER_NAME}'@'%';
    FLUSH PRIVILEGES;
EOSQL

echo "MariaDB setup completed successfully."

# Stop the safe mode MariaDB instance
mysqladmin -u root --socket=/var/run/mysqld/mysqld.sock shutdown

# Start MariaDB normally, replacing the current shell process with the mysqld process
exec mysqld
