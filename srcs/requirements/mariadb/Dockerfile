# Use a lightweight base image
FROM debian:bullseye

# Install MariaDB
RUN apt-get update && apt-get install -y mariadb-server

# Copy a custom MariaDB configuration file
COPY ./conf/50-server.conf /etc/mysql/mariadb.conf.d/

# Set the root password as an environment variable (optional, you can change this)
ENV MYSQL_ROOT_PASSWORD=741

# Expose MariaDB port
EXPOSE 3306

# Start MariaDB when the container launches
CMD ["mysqld"]
