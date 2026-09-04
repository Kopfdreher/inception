#!/bin/bash
set -e

# wait for MariaDB service
until mariadb-admin ping -h"mariadb" --silent; do
	echo "Waiting for MariaDB connection..."
	sleep 2
done

# load secrets
if [ -f /run/secrets/db_password ]; then
	MYSQL_PW=$(cat /run/secrets/db_password)
fi

if [ -f /run/secrets/wp_admin_password ]; then
	WP_ADMIN_PW=$(cat /run/secrets/wp_admin_password)
fi

if [ -f /run/secrets/wp_user_password ]; then
	WP_USER_PW=$(cat /run/secrets/wp_user_pass)
fi

cd /var/www/html

# run WP init if wp-config.php is missing
if [ ! -f wp-config.php ]; then
	wp core download --allow-root

	wp config create \
		--dbname="${MYSQL_DATABASE}" \
		--dbuser="${MYSQL_USER}" \
		--dbpass="${MYSQL_PW}" \
		--dbhost="mariadb:3306" \
		--allow-root

	# primary admin account
	wp core install \
		--url="https://${DOMAIN_NAME}" \
		--title="${WP_TITLE}" \
		--admin_user="${WP_ADMIN_USER}" \
		--admin_password="${WP_ADMIN_PW}" \
		--admin_email="${WP_ADMIN_USER}@${DOMAIN_NAME}" \
		--skip-email \
		--allow-root

	# second user
	wp user create \
		${WP_USER} \
		"user@${DOMAIN_NAME}" \
		--role=author \
		--user_pass=${WP_USER_PW} \
		--allow-root

	chown -R www-data:www-data /var/www/html
fi

mkdir -p /run/php

# start php-fpm as PID 1
exec php-fpm8.2 -F
