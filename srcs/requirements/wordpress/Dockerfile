FROM debian:bullseye

EXPOSE 9000

RUN apt-get update && apt-get install -y \
	php7.4 \
	php7.4-mysql \
	php7.4-fpm \
	ca-certificates \
	curl \
	tar \
	wget \
	mariadb-client

# Create directory for PHP-FPM socket
RUN mkdir -p /run/php
RUN chown www-data: /run/php

COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/

# https://ubuntu.com/tutorials/install-and-configure-wordpress#3-install-wordpress
RUN mkdir -p /srv/www
RUN chown www-data: /srv/www
RUN curl https://wordpress.org/wordpress-6.6.2.tar.gz | tar zx -C /srv/www

COPY conf/wp-config.php /srv/www/wordpress/

COPY ./tools/setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup.sh

ENTRYPOINT	["setup.sh"]
