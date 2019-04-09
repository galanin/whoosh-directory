#!/bin/sh


rm -rf docker/web/public

mkdir -p docker/web/public/assets
mkdir -p docker/web/public/favicon

cp -R public         docker/web/
cp dist/public/*     docker/web/public/assets/
cp -R public/favicon docker/web/public/
