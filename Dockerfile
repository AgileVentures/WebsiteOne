# Use the official Ruby image from Docker Hub
# https://hub.docker.com/_/ruby

# [START cloudrun_rails_base_image]
# Pinning the OS to buster because the nodejs install script is buster-specific.
# Be sure to update the nodejs install command if the base image OS is updated.
FROM ruby:3.0-buster as base
# [END cloudrun_rails_base_image]

RUN (curl -sS https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --dearmor | apt-key add -) && \
    echo "deb https://deb.nodesource.com/node_14.x buster main"      > /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && apt-get install -y nodejs lsb-release

RUN (curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -) && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn

RUN apt-get update -qq && apt-get install -y dos2unix postgresql-client

RUN mkdir /WebsiteOne
WORKDIR /WebsiteOne

COPY Gemfile /WebsiteOne/Gemfile
COPY Gemfile.lock /WebsiteOne/Gemfile.lock

#Production or staging, use middle 2 config lines below when bundling
RUN gem install bundler && \
#    bundle config set --local deployment 'true' && \
#    bundle config set --local without 'development test' && \
    bundle install

COPY package.json /WebsiteOne/package.json
COPY scripts /WebsiteOne/scripts
COPY vendor/assets/javascripts /WebsiteOne/assets/javascripts

FROM base

# To execute tests, install chrome below
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \ 
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list
RUN apt-get update && apt-get -y install google-chrome-stable

RUN dos2unix scripts/copy_javascript_dependencies.js
RUN yarn install
COPY . /WebsiteOne
RUN bundle exec rake assets:precompile

#Production or staging, take out 'bundle' line above and use the following
# ENV RAILS_ENV=production
# ENV RAILS_SERVE_STATIC_FILES=true
# # Redirect Rails log to STDOUT for Cloud Run to capture
# ENV RAILS_LOG_TO_STDOUT=true
# # [START cloudrun_rails_dockerfile_key]
# ARG MASTER_KEY
# ENV RAILS_MASTER_KEY=${MASTER_KEY}
# # [END cloudrun_rails_dockerfile_key]

# # pre-compile Rails assets with master key
# RUN bundle exec rake assets:precompile
# EXPOSE 8080
# CMD ["bin/rails", "server", "-b", "0.0.0.0", "-p", "8080"]

# Also add lines below to database.yml under 'production:'
#  username: av
#  password: <%= Rails.application.credentials.gcp[:db_password] %>
#  host: /cloudsql/av-wso:us-central1:postgres
