#!/bin/bash

 set -e

 bundle check || bundle install --binstubs="$BUNDLE_BIN"
 bundle exec puma -C config/puma.rb
 exec "$@"
