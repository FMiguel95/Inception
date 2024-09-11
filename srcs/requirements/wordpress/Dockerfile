FROM debian:bullseye

EXPOSE 9000

RUN apt-get update && apt-get install -y \
	php7.4 \
	php7.4-mysql \
	php7.4-fpm \
	ca-certificates \
	curl \
	tar 

# https://ubuntu.com/tutorials/install-and-configure-wordpress#3-install-wordpress
RUN mkdir -p /srv/www
RUN chown www-data: /srv/www
RUN curl https://wordpress.org/latest.tar.gz | tar zx -C /srv/www



# Start PHP-FPM
CMD ["php-fpm7.4", "-F"]
