#!/bin/bash

docker-compose down --rmi all --volumes --remove-orphans
docker-compose build --force-rm --no-cache
docker-compose run --rm web rake db:create
docker-compose run --rm web rake db:migrate RAILS_ENV=development
docker-compose run --rm web rake db:seed