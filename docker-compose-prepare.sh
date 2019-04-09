#!/bin/sh

docker/api/prepare.sh

docker/app/prepare.sh

# must follow app build (i.e. after that node static files have been generated)
docker/web/prepare.sh

# After prepare run image building
# docker-compose build
