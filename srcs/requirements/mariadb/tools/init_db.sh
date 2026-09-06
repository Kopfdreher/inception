#!/bin/bash
set -e

echo "[mariadb] starting init"

if [ -f /run/secrets/db_root_password ]; then
	MYSQL_ROOT_PW=$(cat /run/secrets/db_root_password | tr -d '\n')
fi

if [ -f /run/secrets/db_password ]; then
	MYSQL_PW=$(cat /run/secrets/db_password | tr -d '\n')
fi

: "${MYSQL_DATABASE:?MYSQL_DATABASE is not set}"
: "${MYSQL_USER:?MYSQL_USER is not set}"
: "${MYSQL_PW:?MYSQL_PW is not set}"
: "${MYSQL_ROOT_PW:?MYSQL_ROOT_PW is not set}"

if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "[mariadb] installing system tables"
	mariadb-install-db --user=mysql --datadir=/var/lib/mysql

	tmpfile=$(mktemp)
	cat << EOF > "$tmpfile"
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PW}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('${MYSQL_ROOT_PW}');
FLUSH PRIVILEGES;
EOF

	echo "[mariadb] running bootstrap SQL"
	mariadbd --user=mysql --bootstrap < "$tmpfile"
	rm -f "$tmpfile"
	echo "[mariadb] bootstrap done"
else
	echo "[mariadb] data directory already exists, skipping init"
fi

echo "[mariadb] starting server"
exec mariadbd --user=mysql --console
