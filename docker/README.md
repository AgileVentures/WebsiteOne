# How to use docker to spin up WebSiteOne

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

ps: those docker commands were tested under the following environment:

- MacOS 10.13.6
- Docker version 18.06.0-ce, build 0ffa825
- docker-compose version 1.22.0, build f46880f

If it doesn't work for you, try to check your docker version and consider upgrading it if you have an older version.
