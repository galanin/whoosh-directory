FROM ruby:2.6.2-stretch

LABEL maintainer="Serge Galanin <s.galanin@gmail.com>"

WORKDIR /api
ADD api /api
ADD config/mongoid.yml /api/config/
ADD config/puma.rb     /api/config/

RUN bundle install --deployment --without development test --path /usr/local/bundle --binstubs /usr/local/bundle/bin

ENV RACK_ENV=production

EXPOSE 80

CMD ["puma", "-C", "/api/config/puma.rb"]
