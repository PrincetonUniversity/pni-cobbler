#! /bin/bash

##rebuild cobbler server

docker-compose down

docker-compose up -d --build

docker-compose logs -f

