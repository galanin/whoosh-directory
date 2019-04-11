#!/bin/sh

rm -rf docker/import/api

mkdir docker/import/api

cp -R app config demo lib api.rb config.ru Gemfile Gemfile.lock Rakefile version.rb  docker/import/api/
