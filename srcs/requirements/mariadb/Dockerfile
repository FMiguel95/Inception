# Use a lightweight base image
FROM debian:bullseye

# Expose MariaDB port
EXPOSE 3306

# Install MariaDB
RUN apt-get update && apt-get install -y mariadb-server

# Copy a custom MariaDB configuration file
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/

COPY ./tools/setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup.sh

ENTRYPOINT ["setup.sh"]
