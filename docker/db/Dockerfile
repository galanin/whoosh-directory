FROM mongo:4.0.6-xenial

LABEL maintainer="Serge Galanin <s.galanin@gmail.com>"

EXPOSE 27017

ENV MONGO_INITDB_DATABASE=staff
ENV MONGO_INITDB_ROOT_USERNAME=staff
ENV MONGO_INITDB_ROOT_PASSWORD=staff

CMD ["mongod", "--smallfiles", "--wiredTigerCacheSizeGB", "0.25"]
