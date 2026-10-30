# Based on samples/Dockerfile.php516; standalone template build context.
# Experimental until validated on Docker/VS Code. Legacy software: use only with trusted code.
FROM debian:jessie-slim AS builder
RUN rm -f /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian jessie main contrib non-free" > /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian-security jessie/updates main" >> /etc/apt/sources.list && \
    echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/100disablecheckvaliduntil
RUN apt-get update && apt-get install -y --force-yes build-essential flex libxml2-dev libmysqlclient-dev autoconf wget ca-certificates && rm -rf /var/lib/apt/lists/*
WORKDIR /usr/local/src
RUN wget --no-check-certificate https://museum.php.net/php5/php-5.1.6.tar.gz && tar -zxf php-5.1.6.tar.gz
WORKDIR /usr/local/src/php-5.1.6
RUN ./configure --enable-cgi --disable-dom --disable-simplexml --disable-xml --without-pear --enable-mbstring --enable-memory-limit && make && make install
WORKDIR /usr/local/src
# Self-contained: template cannot refer to repository-level samples/ when applied elsewhere.
# Historical Xdebug archive is fetched at build time. Pin checksum after verification.
RUN wget --no-check-certificate https://xdebug.org/files/xdebug-2.0.0.tgz && \
    tar -zxf xdebug-2.0.0.tgz && cd xdebug-2.0.0 && \
    phpize && ./configure --enable-xdebug && make && make install && \
    mkdir -p /usr/local/lib/php/extensions/no-debug-non-zts-20050922 && \
    cp modules/xdebug.so /usr/local/lib/php/extensions/no-debug-non-zts-20050922/xdebug.so
FROM debian:jessie-slim
RUN rm -f /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian jessie main contrib non-free" > /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian-security jessie/updates main" >> /etc/apt/sources.list && \
    echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/100disablecheckvaliduntil
RUN apt-get update && apt-get install -y --force-yes --no-install-recommends apache2 libxml2 libmysqlclient18 libcurl3 libssl1.0.0 && rm -rf /var/lib/apt/lists/*
COPY --from=builder /usr/local/bin/php /usr/local/bin/php
COPY --from=builder /usr/local/lib/php/extensions/no-debug-non-zts-20050922/xdebug.so /usr/local/lib/php/extensions/no-debug-non-zts-20050922/xdebug.so
RUN mkdir -p /usr/lib/cgi-bin && cp /usr/local/bin/php /usr/lib/cgi-bin/php-cgi && chmod 0755 /usr/lib/cgi-bin/php-cgi && \
    printf '\nzend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20050922/xdebug.so\nxdebug.remote_enable=1\nxdebug.remote_autostart=1\nxdebug.remote_connect_back=0\nxdebug.remote_host=host.docker.internal\nxdebug.remote_port=9000\n' >> /usr/local/lib/php.ini
RUN a2dismod mpm_event && a2enmod mpm_prefork cgi actions && \
    printf '\nAddHandler application/x-httpd-php .php\nAction application/x-httpd-php /cgi-bin/php-cgi\nServerName localhost\n' >> /etc/apache2/apache2.conf
ENV APACHE_RUN_USER=www-data APACHE_RUN_GROUP=www-data APACHE_LOG_DIR=/var/log/apache2 APACHE_LOCK_DIR=/var/lock/apache2 APACHE_PID_FILE=/var/run/apache2/apache2.pid APACHE_RUN_DIR=/var/run/apache2
RUN mkdir -p /var/lock/apache2 /var/run/apache2 /var/log/apache2 /var/run/apache2/lock && \
    sed -i 's|Mutex file:${APACHE_LOCK_DIR}|Mutex file:/var/lock/apache2|' /etc/apache2/apache2.conf && a2enconf serve-cgi-bin
WORKDIR /var/www/html
EXPOSE 80
CMD ["sh", "-c", "rm -f \"$APACHE_PID_FILE\" && exec /usr/sbin/apache2 -D FOREGROUND"]
