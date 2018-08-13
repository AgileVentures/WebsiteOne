#!/bin/bash

docker-compose down --rmi all --volumes --remove-orphans
docker-compose build --force-rm --no-cache
DB_HOST=db docker-compose run --rm web rake db:drop
DB_HOST=db docker-compose run --rm web rake db:create
DB_HOST=db docker-compose run --rm web rake db:migrate RAILS_ENV=development
DB_HOST=db docker-compose run --rm web rake db:seed
DB_HOST=db docker-compose run --rm web rake db:test:prepare
