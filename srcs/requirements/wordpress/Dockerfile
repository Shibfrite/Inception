FROM debian:bookworm

RUN apt-get update && apt-get install -y php-fpm php-mysql wget curl mariadb-client \
&& rm -rf /var/lib/apt/lists/*
COPY tools/init.sh /init.sh
RUN chmod +x /init.sh

ENTRYPOINT ["/init.sh"]
