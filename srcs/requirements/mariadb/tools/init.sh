#!/bin/bash

cat <<EOF >/tmp/init.sql
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

exec mysqld --bind-address=0.0.0.0 --init-file=/tmp/init.sql

until mysqladmin ping --silent; do
  sleep 1
done

echo "Ensuring database and user exist..."
if ! mysql -u root -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`; \
                       CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}'; \
                       GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%'; \
                       FLUSH PRIVILEGES;" 2>&1; then
  echo "ERROR: Database creation failed" >&2
  exit 1
fi
echo "Database setup completed."
wait
