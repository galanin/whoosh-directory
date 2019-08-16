Prepare relevant folders
```bash
sudo mkdir -p /var/staff/backup
sudo chown `id -un` /var/staff/backup
sudo mkdir -p /var/staff/import
sudo chown `id -un` /var/staff/import
```

A test run on a dev machine
```bash
./docker-compose-prepare
TAG=r4 docker-compose build

TAG=r4 docker-compose up -d
TAG=r4 docker-compose run --rm --no-deps -e STAFF_DEMO_FILE_PATH=/api/demo/ru/structure.yml import rake full_import[Demo,ru]
TAG=r4 docker-compose kill
```

A more complex test run on a dev machine
```bash
./docker-compose-prepare
TAG=r4 docker-compose build

TAG=r4 docker-compose up -d
TAG=r4 docker-compose run --rm --no-deps -e STAFF_DEMO_FILE_PATH=/api/demo/ru/structure.yml import rake full_import[Demo,ru]
TAG=r4 docker-compose stop
TAG=r4 docker-compose start
TAG=r4 docker-compose kill
``` 

Import data
```bash
rsync -avz ./tmp/import/* /var/staff/import/
TAG=r4 ./docker-compose-production run --rm --no-deps import rake full_import[ONPP,ru]
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
./docker-compose-prepare
TAG=r4 docker-compose build

docker tag staff_db:r4 docker:5000/staff_db:r4
docker tag staff_api:r4 docker:5000/staff_api:r4
docker tag staff_app:r4 docker:5000/staff_app:r4
docker tag staff_web:r4 docker:5000/staff_web:r4

docker push docker:5000/staff_db:r4
docker push docker:5000/staff_api:r4
docker push docker:5000/staff_app:r4
docker push docker:5000/staff_web:r4
```

```bash
docker pull docker:5000/staff_db:r4
docker pull docker:5000/staff_api:r4
docker pull docker:5000/staff_app:r4
docker pull docker:5000/staff_web:r4
```

Export images to tar files
```bash
docker save staff_api:r4 | bzip2 -c1 > images/staff_api_r4.tar.bz2
docker save staff_app:r4 | bzip2 -c1 > images/staff_app_r4.tar.bz2
docker save staff_web:r4 | bzip2 -c1 > images/staff_web_r4.tar.bz2
docker save staff_db:r4  | bzip2 -c1 > images/staff_db_r4.tar.bz2
```

Then import
```bash
docker load < images/staff_api_r4.tar.bz2
docker load < images/staff_app_r4.tar.bz2
docker load < images/staff_web_r4.tar.bz2
docker load < images/staff_db_r4.tar.bz2
```

Then deploy
```bash
TAG=r4 ./docker-compose-production up -d
```


mongo shell
```bash
TAG=r4 docker-compose run --rm --no-deps db mongo -u staff -p staff --authenticationDatabase admin db/staff
```

mongo dump
```bash
TAG=r4 docker-compose run --rm --no-deps db mongodump -u staff -p staff --authenticationDatabase admin -h db -d staff --out /backup
```

mongo restore
```bash
TAG=r4 docker-compose run --rm --no-deps db mongorestore -u staff -p staff --authenticationDatabase admin -h db -d staff --drop /backup
```
