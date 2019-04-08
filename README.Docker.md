A test run on a dev machine
```bash
  ./docker-compose-build.sh
  docker-compose up -d
  docker-compose run --rm -e STAFF_DEMO_FILE_PATH=/api/demo/ru/structure.yml import rake full_import[Demo,ru]
  docker-compose kill
```

A more complex test run on a dev machine
```bash
  ./docker-compose-build.sh
  docker-compose up -d
  docker-compose run --rm -e STAFF_DEMO_FILE_PATH=/api/demo/ru/structure.yml import rake full_import[Demo,ru]
  docker-compose stop
  docker-compose start
  docker-compose kill
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
```


Deploying using a docker registry

Run this on a dev machine:
```bash
  ./docker-compose-build.sh
  docker tag staff_db docker:5000/staff_db
  docker tag staff_api docker:5000/staff_api
  docker tag staff_app docker:5000/staff_app
  docker tag staff_web docker:5000/staff_web
  docker tag staff_import docker:5000/staff_import

  docker push docker:5000/staff_db
  docker push docker:5000/staff_api
  docker push docker:5000/staff_app
  docker push docker:5000/staff_web
  docker push docker:5000/staff_import
```
