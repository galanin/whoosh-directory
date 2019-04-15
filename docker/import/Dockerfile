FROM ruby:2.6.2-stretch

LABEL maintainer="Serge Galanin <s.galanin@gmail.com>"

WORKDIR /api
ADD api /api
RUN bundle install --deployment --without development test --path /usr/local/bundle --binstubs /usr/local/bundle/bin

ADD config/mongoid.yml /api/config/

