NAME = inception
COMPOSE = ./srcs/docker-compose.yml

all: folders up 

folders:
	mkdir -p ~/data
	mkdir -p ~/data/mariadb
	mkdir -p ~/data/wordpress

up:
	docker compose -p $(NAME) -f $(COMPOSE) up --build -d

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
	rm -rf ~/data
	docker system prune -a

re: fclean folders up
