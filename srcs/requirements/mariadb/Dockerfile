FROM debian:bullseye

EXPOSE 3306

RUN apt-get update && apt-get install -y mariadb-server

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/
COPY ./conf/my.cnf /etc/mysql/

COPY ./tools/setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup.sh

ENTRYPOINT ["setup.sh"]
