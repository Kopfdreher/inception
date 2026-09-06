# Developer documentation

## Prerequisites
Linux VM, Docker, Compose, make. Port 443 free. Login `sgavrilo`.

```bash
sudo sh -c 'echo "127.0.0.1 sgavrilo.42.fr" >> /etc/hosts'
cp srcs/.env.example srcs/.env          # set LOGIN=sgavrilo, DOMAIN_NAME=sgavrilo.42.fr
cp secrets/*.txt.example secrets/       # rename: drop .example; put real passwords in the .txt files
```

## Makefile
| Target | Action |
|---|---|
| `make` | create `/home/sgavrilo/data/{mariadb,wordpress}`, then `compose up -d --build` |
| `make down` | stop stack |
| `make clean` | down + `docker system prune -a` |
| `make fclean` | clean + delete data dir and volumes |
| `make re` | fclean + make |

```bash
docker compose -f srcs/docker-compose.yml ps
docker compose -f srcs/docker-compose.yml logs
docker compose -f srcs/docker-compose.yml exec mariadb mariadb -u root
```

## Persistence
Named volumes:
- `inception_mariadb_data` → `/home/sgavrilo/data/mariadb`
- `inception_wordpress_data` → `/home/sgavrilo/data/wordpress`

`docker volume inspect <name>` must contain `/home/sgavrilo/data/`. Data survives reboot; run `make` again after reboot.

## MariaDB login
```bash
docker exec -it mariadb mariadb -u root
SHOW DATABASES;
USE wordpress_db;
SHOW TABLES;
```

DB user `wp_user` (password: `secrets/db_password.txt`).

## Live port change (eval)
Edit `srcs/docker-compose.yml` (`443:443` → e.g. `8443:443`), then `make down && make`. Open `https://sgavrilo.42.fr:8443`. If the container listen port changes, also update `nginx.conf` `listen` and `EXPOSE`.
