A test run on a dev machine
```bash
  ./docker-compose-build.sh
  docker-compose up -d
  docker-compose run --rm --no-deps -e STAFF_DEMO_FILE_PATH=/api/demo/ru/structure.yml import rake full_import[Demo,ru]
  docker-compose kill
```

A more complex test run on a dev machine
```bash
  ./docker-compose-build.sh
  docker-compose up -d
  docker-compose run --rm --no-deps -e STAFF_DEMO_FILE_PATH=/api/demo/ru/structure.yml import rake full_import[Demo,ru]
  docker-compose stop
  docker-compose start
  docker-compose kill
``` 

```bash
  mkdir -p /var/staff/import
  rsync -avz ./import/* /var/staff/import/
  docker-compose run --rm --no-deps import rake full_import[ONPP,ru]
```

Deploying directly
```bash
  # sure docker's port 2376 is open on a target machine
  docker-machine create \
    --engine-storage-driver aufs \
    --driver generic \
    --generic-ip-address=192.168.2.170 \
    --generic-ssh-key ~/.ssh/id_rsa \
    staff
    
  docker-machine env staff
  eval $(docker-machine env staff)
  ./docker-compose-build.sh
  docker compose up -d
  
  eval $(docker-machine env -u)
```


Deploying using a docker registry

Run this on a dev machine:
```bash
  ./docker-compose-build.sh
  docker tag staff_db docker:5000/staff_db
  docker tag staff_api docker:5000/staff_api
  docker tag staff_app docker:5000/staff_app
  docker tag staff_web docker:5000/staff_web

  docker push docker:5000/staff_db
  docker push docker:5000/staff_api
  docker push docker:5000/staff_app
  docker push docker:5000/staff_web
```

```bash
  docker pull docker:5000/staff_db
  docker pull docker:5000/staff_api
  docker pull docker:5000/staff_app
  docker pull docker:5000/staff_web
```

Export images to tar files
```bash
  docker save staff_api | gzip -c > images/staff_api.tar.gz
  docker save staff_app | gzip -c > images/staff_app.tar.gz
  docker save staff_web | gzip -c > images/staff_web.tar.gz
  docker save staff_db  | gzip -c > images/staff_db.tar.gz
  
  docker load < images/staff_api.tar.gz
  docker load < images/staff_app.tar.gz
  docker load < images/staff_web.tar.gz
  docker load < images/staff_db.tar.gz
```

mongo shell
```bash
docker-compose run --rm --no-deps db mongo -u staff -p staff --authenticationDatabase admin db/staff
```

mongo dump
```bash
docker-compose run --rm --no-deps db mongodump -u staff -p staff --authenticationDatabase admin -h db -d staff --out /backup
```

mongo restore
```bash
docker-compose run --rm --no-deps db mongorestore -u staff -p staff --authenticationDatabase admin -h db -d staff --drop /backup
```
