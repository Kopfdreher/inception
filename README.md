*This project has been created as part of the 42 curriculum by sgavrilo.*

# Description
Inception is a small Docker Compose stack: NGINX (TLS1.2/1.3, port 443 only), Wordpress + php-fpm, MariaDB. Each service is build from a custom Debian image. NGINX is the only public entrypoint, Wordpress and MariaDB stay on the internal network.

# Instructions
- Copy srcs/.env.example -> srcs/.env and secrets/*.txt.example -> secrets/*.txt
- /etc/hosts: 127.0.0.1 sgavrilo.42.fr
- From repo root: `make`
- Site: [https://sgavrilo.42.fr](https://sgavrilo.42.fr)
- Stop: `make down`

# Resources
- [DevOps with Docker](https://courses.mooc.fi/org/uh-cs/courses/devops-with-docker)
- [Alejandro's Inception Guide](https://dev.to/alejiri/docker-nginx-wordpress-mariadb-tutorial-inception42-1eok)

## AI Usage
AI was used for debugging and creating a roadmap for the implementation

# Project Description

Custom Debian bookworm images, one Dockerfile per service. Compose builds them, attaches `inception_net`, and mounts two named volumes.

### VMs vs Containers (Docker)
- VM = full guest OS behind a hypervisor.
- Container = isolated process sharing the host kernel. Lighter and faster; less isolation than a VM. This project still runs inside a VM (42 requirement).

### Secrets vs env vars
- `.env` = non-secret config (domain, usernames, DB name).
- Docker secrets = passwords, mounted at `/run/secrets/`. Never put passwords in Dockerfiles or git.

### Docker network vs host network
- User-defined bridge `inception_net`: containers reach each other by name (`wordpress:9000`, `mariadb:3306`). Only NGINX publishes 443.
- `network: host` is forbidden: it would expose every container port on the VM.

### Docker volumes vs bind mounts
- Named volumes `mariadb_data` and `wordpress_data` (required).
- `driver_opts` pin data to `/home/sgavrilo/data/...` so `docker volume inspect` shows that path. Compose bind mounts (`./dir:/dir`) are not used for these stores.