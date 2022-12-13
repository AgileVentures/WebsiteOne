# How to use docker to spin up WebSiteOne

## Prerequisites

In order to run this container you'll need docker installation
* [Windows](https://docs.docker.com/docker-for-windows/)
* [OS X](https://docs.docker.com/docker-for-mac/)
* [Linux](https://docs.docker.com/linux/started/)

## Setup your environment variables

Create a .env file at the root of your directory.

```
$ touch .env
```

* You'll have to get the `.env` file content from one of the admins: @tansaku or @diraulo.  The project won't work without it.  You can send them a direct message (DM) on Slack.  The `.env` file should go in the root of the WSO project.
* Add the following to that file:

```
2_ADDITIONAL_KEYS=please_contact_tansaku_or_diraulo_on_slack
AIRBRAKE_API_KEY=blahblahblah
AIRBRAKE_PROJECT_ID=123
DATABASE_POSTGRESQL_USERNAME=postgres
DATABASE_POSTGRESQL_PASSWORD=postgres
RACK_TIMEOUT_SERVICE_TIMEOUT=200000000
RECAPTCHA_SECRET_KEY=6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WifJWe
RECAPTCHA_SITE_KEY=6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI
SECRET_KEY_BASE=blabla
```

the above are test keys from https://developers.google.com/recaptcha/docs/faq

## Setup docker

Execute this setup just for the first time, or when you want to recreate everything from scratch.

**BE AWARE IT WILL DELETE ALL YOUR DATA, including the Postgres Database.**




```
$ ./docker/setup.sh
```

## Start docker

Start the application

```
$ ./docker/start.sh
```

## Stop docker

Stop the application

```
$ ./docker/stop.sh
```

## Tests inside docker container

To get a shell inside the docker container run:

```
$ docker-compose run --service-ports web bash

```

From there you can run the cucumber tests 

(this takes almost 30min on a i5 laptop from 2017)

```
$ bundle exec cucumber
```

or rspec

```
$ bundle exec rspec
```

or jasmine

```
$ rake assets:clobber
$ rake assets:precompile
$ npx jasmine-browser-runner
```

ps: those docker commands were tested under the following environment:

- MacOS 10.13.6
    - Docker version 18.06.0-ce, build 0ffa825
    - docker-compose version 1.22.0, build f46880f

- Linux Manjaro 17.1.12
    - Docker version 18.06.1-ce, build e68fc7a215
    - docker-compose version 1.22.0


If it doesn't work for you, try to check your docker version and consider upgrading it if you have an older version.
