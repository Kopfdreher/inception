FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    mariadb-server \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/lib/mysql \
    && mkdir -p /run/mysqld /var/lib/mysql /var/log/mysql \
    && chown -R mysql:mysql /run/mysqld /var/lib/mysql /var/log/mysql \
    && chmod 777 /run/mysqld

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/init_db.sh /usr/local/bin/init_db.sh

RUN chmod +x /usr/local/bin/init_db.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/init_db.sh"]
