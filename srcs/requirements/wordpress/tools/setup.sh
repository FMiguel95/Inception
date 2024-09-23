#!/bin/bash

# # Wait for MySQL to be ready.
# # This is necessary because the MySQL container might not be immediately available.
# sleep 5

until mysql -h $DB_HOST -u $DB_USER_NAME -p$DB_USER_PASS -e "show databases;"; do
   echo "Waiting for MySQL..."
   sleep 3
done


# Start PHP-FPM service.
# This is required to run WP-CLI commands.
service php7.4-fpm start

# Install WordPress Command Line Interface (WP-CLI).
# WP-CLI is a set of command-line tools for managing WordPress installations.
wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

# Change to the directory where you want WordPress files to be installed in.
cd /srv/www/wordpress

# Install WordPress using WP-CLI.
# This sets up the core WordPress files and creates the initial configuration.
wp core install \
		--url=$WP_URL \
		--title=$WP_TITLE \
		--admin_user=$WP_ADM_USER \
		--admin_password=$WP_ADM_PASS \
		--admin_email=$WP_ADM_EMAIL \
		--skip-email \
		--allow-root

# Create a new WordPress user if it doesn't already exist.
if ! wp user list --field=user_login --allow-root | grep -q "^$WP_USER$"; then
	wp user create $WP_USER $WP_USER_EMAIL \
		--role=$WP_USER_ROLE \
		--user_pass=$WP_USER_PASS --allow-root
fi

# Install and activate the Classic Editor plugin.
# This ensures compatibility with older WordPress editing interfaces.
wp plugin install classic-editor --activate --allow-root

# Stop PHP-FPM service
# This is done to allow the main PHP-FPM process to start later
service php7.4-fpm stop

# Execute php-fpm7.4 --nodaemonize, which starts the PHP-FPM service in the 
# foreground, without daemonizing it. The --nodaemonize flag is necessary to
# prevent the container from exiting immediately after starting the PHP-FPM. 
exec "$@"