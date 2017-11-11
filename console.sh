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

ORANGE='\033[0;33m' # Orange
NC='\033[0m' # No color
COMPOSE_FILE=$(dirname "$0")/docker-compose.yml

call () {
    docker-compose -f "$COMPOSE_FILE" $*
}


build () {
    echo -e "${ORANGE}BUILDING PROXY-SERVER..${NC}"
    call build --no-cache
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
    echo -e "${ORANGE}STARTING PROXY-SERVER..${NC}"
    call up -d --force-recreate
}

stop () {
    echo -e "${ORANGE}STOPPING PROXY-SERVER..${NC}"
    call stop
}

if [[ $# -eq 1 ]] ; then
    $1

else
    usage
fi

exit 0;
