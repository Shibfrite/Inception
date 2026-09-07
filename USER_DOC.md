# User Documentation

## Services

The stack provides a single website: a WordPress instance, served over HTTPS by NGINX, backed by a MariaDB database. The database is not directly accessible to end users — it only supports the site.

## Starting and stopping

From the repository root:
- `make` — builds and starts all services.
- `make down` — stops and removes all containers.
- `make re` — restarts the stack (down, then up).

Startup can take a minute on first run, while WordPress installs itself.

## Accessing the site

- Website: `https://<DOMAIN_NAME>` (as set in `srcs/.env`)
- Admin panel: `https://<DOMAIN_NAME>/wp-admin`

The certificate is self-signed, so the browser will show a security warning on first visit — this is expected.

## Credentials

All credentials are defined in `srcs/.env`:
- `WP_ADMIN_USER` / `WP_ADMIN_PASSWORD` — WordPress administrator, logs into `/wp-admin`.
- `WP_USER` / `WP_USER_PASSWORD` — secondary WordPress account (editor role).
- `MYSQL_USER` / `MYSQL_PASSWORD` / `MYSQL_DATABASE` — database credentials, used internally by WordPress only.

To change any credential, edit `.env` and run `make re`. Note: existing WordPress accounts are not affected by an `.env` password change alone — update the password from `/wp-admin` as well if it must match.

## Checking that services are running

- `docker ps` — all three containers (`mariadb`, `wordpress`, `nginx`) should show status `Up`.
- `docker logs <container_name>` — check for repeated errors or restart loops.
- Load `https://<DOMAIN_NAME>` in a browser — if the site renders, WordPress and its database connection are working.
