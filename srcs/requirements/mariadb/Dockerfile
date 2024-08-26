# Use a lightweight base image
FROM debian:bullseye

# Install MariaDB
RUN apt-get update && apt-get install -y mariadb-server

# Copy a custom MariaDB configuration file
COPY ./conf/50-server.conf /etc/mysql/mariadb.conf.d/

# Expose MariaDB port
EXPOSE 3306

COPY ./tools/setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup.sh

# Start MariaDB when the container launches
CMD ["setup.sh", "mysql"]
