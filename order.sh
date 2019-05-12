#!/usr/bin/env bash

IMAGE_NAME=php_72_web

CONTAINER_NAME=${IMAGE_NAME}_container

function start () {
  echo "Docker starting..."

  IMAGE_EXISTS=$(docker image ls -q $IMAGE_NAME)

  if [ "$IMAGE_EXISTS" = '' ]; then
    docker build -t $IMAGE_NAME ./
  fi

  CONTAINER_EXISTS=$(docker ps -f name=$CONTAINER_NAME --format '{{.Names}}')

  if [ "$CONTAINER_EXISTS" = '' ]; then
    SCRIPT_DIR=$(cd $(dirname $0); pwd)

    docker run -d -p 80:80 -v $SCRIPT_DIR/src:/var/www/html --name $CONTAINER_NAME $IMAGE_NAME:latest
  else
    echo 'Container is already started.'
  fi

  echo "
  +-----------------------------------+
     PHP & Apache Docker is Started.
            http://localhost/
  +-----------------------------------+
  "
}
function stop () {
  docker stop $CONTAINER_NAME
  docker rm $CONTAINER_NAME
}
function restart () {
  stop
  start
}
function destroy() {
  docker rmi -f $IMAGE_NAME
}
function connect () {
  docker exec -it $CONTAINER_NAME /bin/bash
}
function help () {
  echo "
  +--------------------------------------------------+
           +-+- PHP & Apache Docker Help -+-+

      start   : Starting Image & Container
      stop    : Stop the container.
      restart : Reboot the container.
      destroy : Delete containers and images.
      conn    : Connect to app container.
      help    : Display help.
  +--------------------------------------------------+
  "
}
function error_msg () {
  echo "Argument is missing. Please display help and check the argument.
  exp.) sh order.sh help
  "
}

case "$1" in
  "start"   ) start       ;;
  "stop"    ) stop        ;;
  "restart" ) restart     ;;
  "destroy" ) destroy     ;;
  "conn"    ) connect     ;;
  "help"    ) help        ;;
  ""        ) error_msg   ;;
esac
