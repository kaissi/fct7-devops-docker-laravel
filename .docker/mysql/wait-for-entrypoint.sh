#!/bin/sh

rm -f /.start_healthcheck

health-server &

touch /.start_healthcheck

exec docker-entrypoint.sh "${@}"
