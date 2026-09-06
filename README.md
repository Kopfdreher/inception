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

### VMs vs Containers (Docker)
- VM = fully virtualized guest OS 
- Container = isolated processes, sharing the host kernel

### Secrets vs env vars
- .env