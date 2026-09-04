#!/bin/bash
set -e

mkdir -p /etc/nginx/ssl

if [ ! -f /etc/nginx/ssl/nginx.crt ]; then
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout /etc/nginx/ssl/nginx.key \
		-out /etc/nginx/ssl/nginx.crt \
		-subj "/C=DE/ST=Berlin/L=Berlin/O=42/OU=42/CN=${DOMAIN_NAME}"
fi

sed -i "s/DOMAIN_NAME_PLACEHOLDER/${DOMAIN_NAME}/g" /etc/nginx/nginx.conf

exec nginx -g "daemon off;"
