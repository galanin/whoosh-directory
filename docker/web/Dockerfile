FROM nginx:1.15.9

LABEL maintainer="Serge Galanin <s.galanin@gmail.com>"

COPY conf/nginx.conf   /etc/nginx/nginx.conf
COPY conf/default.conf /etc/nginx/conf.d/default.conf

WORKDIR /public
ADD public /public

EXPOSE 80
