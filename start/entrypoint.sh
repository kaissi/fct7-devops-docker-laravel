#!/bin/sh

echo ">> Waiting for MySQL be ready..."

until curl -f -s http://db:${MYSQL_HEALTH_PORT_TARGET}/readiness > /dev/null; do
    sleep 1
done;

echo ">> MySQL ready!"

echo ">> Executing 'composer install'"
composer install

echo ">> Executing 'php artisan key:generate'"
php artisan key:generate 

echo ">> Executing 'php artisan migrate'"
php artisan migrate

echo ">> Executing 'php-fpm'"
exec php-fpm "${@}"
