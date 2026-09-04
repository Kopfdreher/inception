#!/bin/bash
set -e

# Load secrets from files into variables
if [ -f /run/secrets/db_root_password ]; then
	MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
fi

if [ -f /run/secrets/db_password ]; then
	MYSQL_PASSWORD=$(cat /run/secrets/db_password)
fi

# Init data dir if db does not exit
if [ ! -d "/var/lib/mysql/mysql" ]; then
	mariadb-install-db --user=mysql --datadir=/var/lib/mysql > /dev/null

	tmpfile=$(mktemp)
	cat << EOF > "$tmpfile"
USE mysql;
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

	# Exec setup cmds in bootstrap mode without starting network daemon
	mariadbd --user=mysql --bootstrap < "$tmpfile"
	rm -f "$tmpfile"
fi

# Starting MariaDB as PID 1
exec mariadbd --user=mysql --console
