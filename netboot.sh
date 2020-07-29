#! /bin/bash

docker-compose exec cobblerd cobbler system edit --name=$1 --netboot-enable=true
