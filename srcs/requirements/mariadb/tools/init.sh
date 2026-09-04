#!/bin/bash
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

cat <<EOF >/tmp/init.sql
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

#echo "STARTING MARIADB"
service mariadb start
until mysqladmin ping --silent; do sleep 1; done
#echo "DAEMON OK, running SQL"

mariadb </tmp/init.sql
#echo "SQL DONE, stopping"

service mariadb stop
#echo "STOP ISSUED, waiting for pgrep loop"
while pgrep -x mysqld >/dev/null; do sleep 1; done
#echo "PGREP LOOP DONE, exec mysqld_safe"

exec mysqld_safe --bind-address=0.0.0.0
