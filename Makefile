NAME = inception
COMPOSE = ./srcs/docker-compose.yml

all: folders up 

folders:
	mkdir -p /home/fernacar/data
	mkdir -p /home/fernacar/data/mariadb
	mkdir -p /home/fernacar/data/wordpress

up:
	docker compose -p $(NAME) -f $(COMPOSE) up --build -d --force-recreate

down:
	docker compose -p $(NAME) -f $(COMPOSE) down --volumes

start:
	docker compose -p $(NAME) start

stop:
	docker compose -p $(NAME) -f $(COMPOSE) stop

rm-image:
	docker rmi -f $$(docker images -q)

clean: down rm-image

fclean: clean
	sudo rm -rf /home/fernacar/data
	docker system prune -a --volumes

re: fclean folders up
