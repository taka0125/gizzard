#!/bin/bash
set -ex

CURRENT=$(cd $(dirname $0);pwd)
DOCKER_MYSQL_PORT=$(docker port gizzard_mysql57 3306 2>/dev/null | cut -f 2 -d ':')
DOCKER_MYSQL_PORT=${DOCKER_MYSQL_PORT:-3306}

export DB_HOST=${DB_HOST:-127.0.0.1}
export DB_PORT=${DB_PORT:-${DOCKER_MYSQL_PORT}}
export DB_NAME=${DB_NAME:-gizzard_test}
export DB_USER=${DB_USER:-root}
export DB_PASSWORD=${DB_PASSWORD:-5y8m2jzTamDS6M85ateGrA6pihhyCm}

mysql \
  -u ${DB_USER} \
  -h ${DB_HOST} \
  -p${DB_PASSWORD} \
  --port ${DB_PORT} \
  -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME}"

bundle exec ridgepole \
  -c ${CURRENT}/../spec/dummy/config/database.yml \
  --apply \
  -f ${CURRENT}/../spec/dummy/db/Schemafile \
  -E test
