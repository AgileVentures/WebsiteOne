#!/bin/bash

 set -e

 bundle check || bundle install binstubs --all

 exec "$@"
