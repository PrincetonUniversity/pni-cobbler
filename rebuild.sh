#! /bin/bash

##rebuild cobbler server

docker-compose stop
docker-compose rm -f

docker-compose up -d
