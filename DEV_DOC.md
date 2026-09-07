# Developer Documentation

## Prerequisites

- A Linux virtual machine.
- Docker and Docker Compose.
- Sudo rights on the VM (the Makefile runs `docker compose` via sudo).

## Configuration

All configuration lives in `srcs/.env`, read by both the Makefile and each service's `env_file`. Required variables:
- `VM_PASSWORD` — sudo password, used by the Makefile.
- `DOMAIN_NAME`, `WP_TITLE`
- `MYSQL_DATABASE`, `MYSQL_USER`, `MYSQL_PASSWORD`
- `WP_ADMIN_USER`, `WP_ADMIN_PASSWORD`, `WP_ADMIN_EMAIL`
- `WP_USER`, `WP_USER_PASSWORD`, `WP_USER_EMAIL`

`.env` is not committed to the repository; credentials are handled as plain environment variables rather than Docker secrets.

## Build and launch

From the repository root:
- `make` — builds all images and starts the stack (`docker compose up --build`).
- `make down` — stops and removes containers.
- `make re` — `down` then `make` again.
- `make clean` — `down`, then `docker system prune -af`.
- `make fclean` — `clean`, then removes all Docker volumes.

## Managing containers and volumes

- `docker ps` — list running containers.
- `docker logs -f <container_name>` — follow a container's stdout/stderr.
- `docker exec -it <container_name> bash` — shell into a running container.
- `docker compose -f srcs/docker-compose.yml restart <service>` — restart one service.
- `docker volume ls` / `docker volume inspect <volume_name>` — list/inspect volumes.

## Data storage and persistence

Two named volumes are declared in `docker-compose.yml`, both configured with `bind` driver options, mapping directly to fixed host paths:
- `db_data` → `/home/makurek/data/mariadb` — MariaDB's data directory.
- `wp_files` → `/home/makurek/data/wordpress` — WordPress core files, uploads, themes, plugins.

Because these are host directories, data survives `docker compose down` and container rebuilds. It is only removed by deleting the host folders directly, or via `make fclean`, which removes the Docker volumes (the underlying host data itself must still be cleared manually if a fully empty state is needed, since bind-mounted content is not deleted by volume removal alone).

Note: WordPress's entrypoint script wipes and reinstalls `/var/www/html` on every container start, regardless of volume state — so themes, plugins, and uploads do not persist across restarts, even though the database does.
