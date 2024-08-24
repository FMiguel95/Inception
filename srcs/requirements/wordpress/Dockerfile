# Use a lightweight base image like Debian or Ubuntu
FROM debian:bullseye

# Install PHP, PHP-FPM, and required PHP extensions
RUN apt-get update && apt-get install -y \
    php-fpm \
    php-mysql \
    curl \
    wget \
    unzip \
    && apt-get clean

# Download and set up WordPress
RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xvzf latest.tar.gz && \
    rm latest.tar.gz && \
    mv wordpress/* /var/www/html/ && \
    rm -rf wordpress

# Set correct permissions for WordPress
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Configure PHP-FPM to run in the foreground
RUN sed -i 's/;daemonize = yes/daemonize = no/' /etc/php/7.4/fpm/php-fpm.conf

# Expose port 9000 for PHP-FPM
EXPOSE 9000

# Start PHP-FPM
CMD ["php-fpm7.4", "-F"]
