#!/bin/bash

usage () {

cat << EOF
Commands:
    (only for cloned project)
    call: Function to call docker-compose ...

    build: build --no-cache
    certbot: Calls Let's Encrypt certbot command
    rebuild: stop + build + start
    restart: stop + start
    start: Start containers by calling docker-compose up -d --force-recreate
    stop: Stops containers by calling docker-compose stop
EOF
}


CONTAINER_NAME=proxy-server
ORANGE='\033[0;33m' # Orange
NC='\033[0m' # No color
COMPOSE_FILE=$(dirname "$0")/docker-compose.yml


call () {
    docker-compose -f "$COMPOSE_FILE" $*
}


certbot () {
    EXECUTE_COMMAND=exec

    echo -e "${ORANGE}GENERATING LETSENCRYPT CERTIFICATE..${NC}"

    if [ ! "$(docker ps -q -f name="$CONTAINER_NAME")" ]; then
        EXECUTE_COMMAND=run
    fi

    call "$EXECUTE_COMMAND" server certbot $*
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


if [[ $# -eq 0 ]] ; then
    usage

else
    $*
fi

exit 0;
