#!/bin/sh

rm -rf dist
mkdir dist

yarn install

for i in $(cat docker/app/.env); do
  export $i
done

yarn run prod:build:client && \
yarn run prod:build:ssr && \
yarn run prod:build:server

rm -rf docker/app/app
mkdir docker/app/app

cp -R client common dist server package.json react-loadable.json webpack-assets.json  docker/app/app/

mkdir -p docker/app/app/config
cp config/index.js  docker/app/app/config/

cp -R node_modules  docker/app/app/
