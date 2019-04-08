#!/bin/sh

docker/api/build.sh
docker/import/build.sh

docker/app/build.sh

# must follow app build (i.e. after that node static files have been generated)
docker/web/build.sh

docker-compose build
