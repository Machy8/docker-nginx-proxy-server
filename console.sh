#!/bin/bash

usage () {

cat << EOF
Commands:
    call: Function to call docker-compose ...

    build: build --no-cache
    rebuild: stop + build + start
    restart: stop + start
    start: call up
    stop: call stop + rm
EOF
}

COMPOSE_FILE=$(dirname "$0")/docker-compose.yml

build () {
    call build --no-cache
}

call () {
    docker-compose -f "$COMPOSE_FILE" $*
}

rebuild () {
    stop
    build
    start
}

restart () {
    stop
    start
}

start () {
    call up -d
}

stop () {
    call stop
    call rm -f
}

if [[ $# -eq 1 ]] ; then
    $1

else
    usage
fi

exit 0;
