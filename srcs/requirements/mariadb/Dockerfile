# Use a lightweight base image
FROM debian:bullseye

# MariaDB Variables
ENV DB_NAME="wp_database"
ENV DB_USER_NAME="dbuser"
ENV DB_USER_PASS="123"
ENV DB_ROOT_PASS="123"
ENV DB_HOST="mariadb"

# Expose MariaDB port
EXPOSE 3306

# Install MariaDB
RUN apt-get update && apt-get install -y mariadb-server

# Copy a custom MariaDB configuration file
COPY ./conf/50-server.conf /etc/mysql/mariadb.conf.d/

COPY ./tools/setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup.sh

# Start MariaDB when the container launches
ENTRYPOINT [ "setup.sh" ]
CMD ["mariadb"]
