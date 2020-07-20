FROM mysql:5.7

ARG HEALTH_READINESS_FILE

COPY --from=kaissi/health-server:latest /usr/local/health-server/health-server /usr/local/bin/

COPY wait-for-entrypoint.sh /usr/local/bin/
COPY ${HEALTH_READINESS_FILE} /usr/local/bin/

RUN usermod -u 1000 mysql

ENTRYPOINT [ "wait-for-entrypoint.sh" ]