# User documentation

## Services
- **NGINX** — HTTPS only (port 443), TLS 1.2/1.3.
- **WordPress** — php-fpm, no public port.
- **MariaDB** — database, no public port.

## Start / stop
From the repo root (after `.env` and `secrets/*.txt` exist — see DEV_DOC.md):

```bash
make
make down
```

## Website
- Site: https://sgavrilo.42.fr (accept the self-signed certificate).
- Admin: https://sgavrilo.42.fr/wp-admin
- HTTP (http://sgavrilo.42.fr) does not work.

Need `/etc/hosts`: `127.0.0.1 sgavrilo.42.fr`

## Credentials
Usernames in `secrets/credentials.txt`:
- WP admin: `site_owner`
- WP user: `regular_user`

Passwords are only in the local files `secrets/wp_admin_password.txt` and `secrets/wp_user_password.txt` (not in git).

## Health checks
```bash
docker compose -f srcs/docker-compose.yml ps
docker compose -f srcs/docker-compose.yml logs
```

The site should show WordPress, not the installation wizard.
