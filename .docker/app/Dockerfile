ARG DOCKER_LARAVEL_TAG="base"
FROM kaissi/devops-docker-laravel:${DOCKER_LARAVEL_TAG}

ARG MYSQL_HOST
ARG MYSQL_PORT
ARG MYSQL_DATABASE
ARG MYSQL_USER
ARG MYSQL_ROOT_PASSWORD
ARG REDIS_HOST
ARG APP_HOST
ARG APP_PORT
ENV \
    MYSQL_HOST="${MYSQL_HOST}" \
    MYSQL_PORT="${MYSQL_PORT}" \
    MYSQL_DATABASE="${MYSQL_DATABASE}" \
    MYSQL_USER="${MYSQL_USER}" \
    MYSQL_ROOT_PASSWORD="${MYSQL_ROOT_PASSWORD}" \
    REDIS_HOST="${REDIS_HOST}" \
    APP_HOST="${APP_HOST}" \
    APP_PORT="${APP_PORT}"

USER root
RUN sed -i "s/#*\s*listen\s\+=\s\+127.0.0.1:9000/listen = 127.0.0.1:${APP_PORT}/;" \
        /usr/local/etc/php-fpm.d/www.conf.default \
        /usr/local/etc/php-fpm.d/www.conf \
    && sed -i "s/#*\s*listen\s\+=\s\+9000/listen = ${APP_PORT}/;" \
        /usr/local/etc/php-fpm.d/zz-docker.conf
USER www-data

EXPOSE ${APP_PORT}

ENTRYPOINT [ "/bin/sh" , "-c", "exec \
    dockerize \
        -template ./.docker/app/.env.tmpl:.env \
        -wait tcp://${MYSQL_HOST}:${MYSQL_PORT} \
        -timeout 20s \
        entrypoint.sh" \
]
