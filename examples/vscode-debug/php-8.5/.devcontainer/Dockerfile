FROM php:8.5-apache

RUN pecl install xdebug-3.5.3 && \
    docker-php-ext-enable xdebug && \
    printf '\nxdebug.mode=debug,develop\nxdebug.start_with_request=trigger\nxdebug.client_host=127.0.0.1\nxdebug.client_port=9003\n' > /usr/local/etc/php/conf.d/99-xdebug.ini && \
    printf '\nServerName localhost\n' >> /etc/apache2/apache2.conf
