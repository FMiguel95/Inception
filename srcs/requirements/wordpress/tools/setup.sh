#!/bin/bash

# Wait for mariadb to be ready
RETRY_COUNT=0
until mysqladmin -u root -p"$(cat /run/secrets/db_root_pass)" ping -h "$DB_HOST" --silent; do
	if [ $RETRY_COUNT -ge 10 ]; then
		echo "MariaDB timeout. Exiting..."
		exit 1
	fi
	echo "Waiting for MariaDB to be ready... ($RETRY_COUNT)"
	sleep 2
	RETRY_COUNT=$((RETRY_COUNT + 1))
done
echo "MariaDB is ready!"

# https://wp-cli.org/
wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

cd /srv/www/wordpress

# https://make.wordpress.org/cli/handbook/how-to/how-to-install/#step-4-install-wordpress
wp core install \
		--url=$WP_URL \
		--title=$WP_TITLE \
		--admin_user=$(cat /run/secrets/wp_adm_user) \
		--admin_password=$(cat /run/secrets/wp_adm_pass) \
		--admin_email=$(cat /run/secrets/wp_adm_email) \
		--skip-email \
		--allow-root

# Create a new WordPress user if it doesn't already exist.
if ! wp user list --field=user_login --allow-root | grep -q "^$(cat /run/secrets/wp_user_name)$"; then
	wp user create $(cat /run/secrets/wp_user_name) $(cat /run/secrets/wp_user_email) --role="author" --user_pass=$(cat /run/secrets/wp_user_pass) --allow-root
fi

# -F forces it to run in the foreground
exec php-fpm7.4 -F
