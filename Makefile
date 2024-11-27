.PHONY: up down start stop clean fclean re

NETWORK_NAME = inception
COMPOSE_FILE = ./srcs/docker-compose.yml
VOLUME_DIR = /home/fernacar/data
VOLUME_WORDPRESS_DIR = $(addprefix $(VOLUME_DIR), /wordpress)
VOLUME_MARIADB_DIR = $(addprefix $(VOLUME_DIR), /mariadb)

all: up 

$(VOLUME_WORDPRESS_DIR):
	mkdir -p $(VOLUME_WORDPRESS_DIR)

$(VOLUME_MARIADB_DIR):
	mkdir -p $(VOLUME_MARIADB_DIR)

up: $(VOLUME_WORDPRESS_DIR) $(VOLUME_MARIADB_DIR)
	docker compose -p $(NETWORK_NAME) -f $(COMPOSE_FILE) up --build -d

down:
	docker compose -p $(NETWORK_NAME) -f $(COMPOSE_FILE) down --volumes

start:
	docker compose -p $(NETWORK_NAME) start

stop:
	docker compose -p $(NETWORK_NAME) -f $(COMPOSE_FILE) stop

clean: down
	docker rmi -f $$(docker images -q) || true

fclean: clean
	docker system prune -a --volumes
	sudo rm -fr $(VOLUME_DIR)

re: fclean up
