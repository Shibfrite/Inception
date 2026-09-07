include srcs/.env
all:
	echo $(VM_PASSWORD) | sudo -S docker compose -f srcs/docker-compose.yml up --build

down:
	echo $(VM_PASSWORD) | sudo -S docker compose -f srcs/docker-compose.yml down

re: down all

clean: down
	echo $(VM_PASSWORD) | sudo -S docker system prune -af

fclean: clean
	echo $(VM_PASSWORD) | sudo -S docker volume rm $$(docker volume ls -q)
