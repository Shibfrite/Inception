#!/bin/bash

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

cat <<EOF >/tmp/init.sql
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

service mariadb start
while pgrep -x mysqld >/dev/null; do
	sleep 1
done
mariadb < /tmp/init.sql
service mariadb end

exec mysqld_safe
#exec mysqld --bind-address=0.0.0.0 --init-file=/tmp/init.sql
