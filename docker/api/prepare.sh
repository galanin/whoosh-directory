#!/bin/sh

rm -rf docker/api/api

mkdir docker/api/api

cp -R app config demo lib api.rb config.ru Gemfile Gemfile.lock Rakefile version.rb  docker/api/api/
