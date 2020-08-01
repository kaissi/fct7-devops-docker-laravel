FROM nginx:1.15.0-alpine

ARG APP_HOST
ARG APP_PORT
ARG DOCKERIZE_VERSION
ENV \
    APP_HOST="${APP_HOST}" \
    APP_PORT="${APP_PORT}" \
    DOCKERIZE_VERSION="${DOCKERIZE_VERSION}"

RUN rm /etc/nginx/conf.d/default.conf \
    && apk add --no-cache \
        openssl \
    && wget https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_VERSION}/dockerize-alpine-linux-amd64-${DOCKERIZE_VERSION}.tar.gz \
        && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-${DOCKERIZE_VERSION}.tar.gz \
        && rm dockerize-alpine-linux-amd64-${DOCKERIZE_VERSION}.tar.gz

COPY ./nginx.conf.tmpl /tmp

ENTRYPOINT [ "/bin/sh", "-c", "exec \
    dockerize \
        -template ./tmp/nginx.conf.tmpl:/etc/nginx/conf.d/nginx.conf \
        -wait tcp://${APP_HOST}:${APP_PORT} \
        -timeout 20s \
        nginx -g 'daemon off;'" \
]
