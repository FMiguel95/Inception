# Use a lightweight base image
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install MariaDB
RUN apt-get update && apt-get install -y mariadb-server mariadb-client

# Expose MariaDB port
EXPOSE 3306

# Copy a custom MariaDB configuration file, if you have one (optional)
# COPY my.cnf /etc/mysql/my.cnf

# Set the root password as an environment variable (optional, you can change this)
ENV MYSQL_ROOT_PASSWORD=my_root_password

# Start MariaDB when the container launches
CMD ["mysqld"]

