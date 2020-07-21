FROM mysql:5.7

ENV DOCKERIZE_VERSION v0.6.1

RUN apt update \
    && apt install -y --no-install-recommends \
        ca-certificates \
        wget \
    && rm -rf /var/lib/apt/lists/* \
    && wget https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_VERSION}/dockerize-linux-amd64-${DOCKERIZE_VERSION}.tar.gz \
        && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-${DOCKERIZE_VERSION}.tar.gz \
        && rm dockerize-linux-amd64-${DOCKERIZE_VERSION}.tar.gz \
    && usermod -u 1000 mysql
