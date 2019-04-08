#!/bin/sh

rm -rf docker/api/api

mkdir docker/api/api

cp -R app config api.rb config.ru Gemfile Gemfile.lock version.rb  docker/api/api/
