#!/bin/sh

if [ ! -f /.start_healthcheck ]; then
    exit 1
fi

result=`mysql -u "${MYSQL_USER}" --database="${MYSQL_DATABASE}" --password="${MYSQL_ROOT_PASSWORD}" --execute='SELECT 1 FROM dual;' --skip-column-names -B`
if [ "${result}" = "1" ]; then
    exit 0
else
    exit 1
fi

