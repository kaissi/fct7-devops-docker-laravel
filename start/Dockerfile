FROM php:7.3.6-fpm-alpine3.9

RUN apk add --no-cache \
        shadow \
        mysql-client \
    && docker-php-ext-install pdo pdo_mysql \
    && rm -rf /var/www/html

WORKDIR /var/www

COPY composer-installer.sh /tmp
COPY entrypoint.sh /usr/local/bin

RUN usermod -u 1000 www-data \
    && chown -R www-data.www-data /var/www \
    && /tmp/composer-installer.sh \
    && mv composer.phar /usr/local/bin/composer
USER www-data

VOLUME /var/www

RUN composer create-project laravel/laravel . \
    && ln -s public html

EXPOSE 9000

ENTRYPOINT ["entrypoint.sh"]
