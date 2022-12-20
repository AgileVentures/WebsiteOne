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

RUN gem install bundler && \
#   Production, use the following
#    bundle config set --local deployment 'true' && \
#    bundle config set --local without 'development test' && \
    bundle install

COPY package.json /WebsiteOne/package.json
COPY scripts /WebsiteOne/scripts
COPY vendor/assets/javascripts /WebsiteOne/assets/javascripts

FROM base

RUN dos2unix scripts/copy_javascript_dependencies.js
# To execute tests, install chrome below
# RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \ 
#     && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list
# RUN apt-get update && apt-get -y install google-chrome-stable
RUN yarn install
COPY . /WebsiteOne

#Production or staging, use the following
# ENV RAILS_LOG_TO_STDOUT true
# ENV RAILS_SERVE_STATIC_FILES true
# ENV PORT 8080
# # Set DB_PASS environment variable from ARG
# ARG DB_PASS
# ENV DATABASE_PASSWORD=${DB_PASS}
# ENV DATABASE_POSTGRESQL_USERNAME=postgres
# ENV DATABASE_POSTGRESQL_PASSWORD=postgres
# # Set RAILS_MASTER_KEY to config/master.key from ARG
# ARG MASTER_KEY
# ENV RAILS_MASTER_KEY=${MASTER_KEY}
# # Expose Puma port
# EXPOSE 8080
# RUN chmod +x /WebsiteOne/entrypoint.sh
# ENTRYPOINT ["/WebsiteOne/entrypoint.sh"]
