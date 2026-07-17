#!/bin/bash

wget -q https://wordpress.org/latest.tar.gz -P /tmp
tar -xzf /tmp/latest.tar.gz -C /tmp
mkdir -p /var/www/html
mv /tmp/wordpress/* /var/www/html/

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

# Wait for MariaDB to be ready
sleep 5

wp config create \
  --dbname=wordpress \
  --dbuser=wpuser \
  --dbpass=wppassword \
  --dbhost=mariadb \
  --path=/var/www/html \
  --allow-root

wp core install \
  --url=localhost \
  --title="Inception" \
  --admin_user=myadmin \
  --admin_password=adminpass \
  --admin_email=admin@example.com \
  --path=/var/www/html \
  --allow-root

wp user create editor editor@example.com \
  --role=editor \
  --user_pass=editorpass \
  --path=/var/www/html \
  --allow-root

mkdir -p /run/php
exec php-fpm7.4 -F
