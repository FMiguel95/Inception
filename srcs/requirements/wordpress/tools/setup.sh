#!/bin/bash

# Wait for MySQL to be ready
until mysqladmin ping -h "$DB_HOST" --silent; do
    echo "Waiting for MySQL to be ready..."
    sleep 2
done

# # Start PHP-FPM service.
# # This is required to run WP-CLI commands.
# service php7.4-fpm start

# https://wp-cli.org/
# Install WP-CLI
wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

# Change to the directory where you want WordPress files to be installed in.
cd /srv/www/wordpress

# https://make.wordpress.org/cli/handbook/how-to/how-to-install/#step-4-install-wordpress
# Install WordPress using WP-CLI.
wp core install \
		--url=$WP_URL \
		--title=$WP_TITLE \
		--admin_user=$WP_ADM_USER \
		--admin_password=$(cat /run/secrets/wp_adm_pass) \
		--admin_email=$WP_ADM_EMAIL \
		--skip-email \
		--allow-root

# Create a new WordPress user if it doesn't already exist.
if ! wp user list --field=user_login --allow-root | grep -q "^$WP_USER$"; then
	wp user create $WP_USER $WP_USER_EMAIL --role="author" --user_pass=$(cat /run/secrets/wp_user_pass) --allow-root
fi

# Install and activate the Classic Editor plugin.
# This ensures compatibility with older WordPress editing interfaces.
# wp plugin install classic-editor --activate --allow-root

# # Stop PHP-FPM service
# # This is done to allow the main PHP-FPM process to start later
# service php7.4-fpm stop

# Execute php-fpm7.4 --nodaemonize, which starts the PHP-FPM service in the 
# foreground, without daemonizing it. The --nodaemonize flag is necessary to
# prevent the container from exiting immediately after starting the PHP-FPM. 
exec php-fpm7.4 --nodaemonize
