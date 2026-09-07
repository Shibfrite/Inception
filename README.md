This project has been created as part of the 42 curriculum by makurek.

# Description

Inception is a system administration project from the 42 curriculum. Its goal is to deploy a small web infrastructure entirely through Docker, with each service isolated in its own container and orchestrated via Docker Compose, running inside a dedicated virtual machine.

The stack consists of three custom-built containers:

NGINX — TLS entrypoint and reverse proxy.
WordPress — PHP-FPM application server, installed and configured via WP-CLI.
MariaDB — database server backing WordPress.


# Instructions
Prerequisites: a Linux VM, Docker, Docker Compose, sudo rights.

Fill srcs/.env with the required variables (domain name, database name/user/password, WordPress admin and editor credentials, VM sudo password).
Run make to build the images and start the stack.
Access the site at https://<DOMAIN_NAME> (self-signed certificate — expect a browser warning).

Other targets:

make down — stop and remove the containers.
make re — down, then rebuild and restart.
make clean — down, then prune unused Docker resources.
make fclean — clean, then remove all Docker volumes.
Project Description

Each service runs from its own Dockerfile (Debian bookworm base), one main process per container, with entrypoint scripts handling initialization before starting the foreground process:

mariadb: initializes the datadir on first run, creates the database and user, listens on port 3306.
wordpress: installs WordPress via WP-CLI against the mariadb host, PHP-FPM listens on port 9000.
nginx: terminates TLS on port 443, forwards PHP requests to wordpress:9000 over FastCGI.

Persistent data (database files, WordPress files) is written to fixed host paths under /home/makurek/data, and containers communicate over a single user-defined Docker network.

VM vs Docker — A VM virtualizes hardware and runs a full guest OS with its own kernel, giving strong isolation with higher startup time and resource use. Docker containers share the host kernel and isolate processes making them far lighter and faster to start but the isolation is weaker.

Secrets vs Environment Variables — Environment variables (as used here, via .env/env_file) are simple but stored in plaintext and visible via docker inspect or within the container's process environment. Docker secrets are encrypted at rest and exposed only as files to the services that need them, but require Swarm mode. This project uses environment variables, since plain Compose is used.

Docker Network vs Host Network — A container on the host network shares the host's network namespace directly: no isolation, no per-container DNS name. A container on a Docker (bridge) network is isolated, reachable by container name through Docker's embedded DNS, with ports published explicitly. This project defines a dedicated bridge network, letting WordPress reach MariaDB simply by the hostname mariadb.

Docker Volumes vs Bind Mounts — A named volume is managed by Docker under its own storage area, decoupled from any specific host path. A bind mount maps a specific, pre-existing host directory directly into the container. This project declares named volumes but configures them with bind-mount driver options (type: none, o: bind, fixed device path), so data persists at explicit host locations while still being declared as volumes in the Compose file.

# Resources
MariaDB documentation
WordPress WP-CLI documentation
NGINX documentation
Docker documentation: Dockerfile reference, Compose file reference, networking, volumes

AI usage:
Claude was used to diagnose various bugs, and to make the md files.
Fixes where applied by myself.
