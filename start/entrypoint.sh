#!/bin/sh

echo ">> Executing 'composer install'"
composer install

echo ">> Executing 'php artisan key:generate'"
php artisan key:generate 

echo ">> Executing 'php artisan migrate'"
php artisan migrate

echo ">> Executing 'php-fpm'"
exec php-fpm "${@}"
