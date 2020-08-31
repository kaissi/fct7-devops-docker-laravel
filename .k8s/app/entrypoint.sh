#!/bin/sh

echo ">> Creating link to application"
ln -s /var/www /usr/share/nginx

echo ">> Executing 'php artisan config:cache'"
php artisan config:cache

echo ">> Executing 'php artisan migrate'"
php artisan migrate

echo ">> Executing 'php-fpm'"
exec php-fpm "${@}"
