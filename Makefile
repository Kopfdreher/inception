NAME = inception
COMPOSE_FILE = srcs/docker-compose.yml
LOGIN = $(shell grep LOGIN srcs/.env | cut -d '=' -f2)
DATA_DIR = /home/$(LOGIN)/data

all: prepare up

prepare:
	@mkdir -p $(DATA_DIR)/mariadb
	@mkdir -p $(DATA_DIR)/wordpress

build: prepare
	docker compose -f $(COMPOSE_FILE) build

up: prepare
	docker compose -f $(COMPOSE_FILE) up -d --build

down:
	docker compose -f $(COMPOSE_FILE) down

clean: down
	docker system prune -a -f

fclean: clean
	@if [ -d "$(DATA_DIR)" ]; then \
		sudo rm -rf $(DATA_DIR); \
	fi
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true

re: fclean all

.PHONY: all build up down clean fclean re prepare
