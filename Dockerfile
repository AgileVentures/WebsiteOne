FROM ruby:2.5

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get update -qq && apt-get install -y build-essential \
    libpq-dev nodejs && rm -rf /var/cache/apt/archives/*

RUN mkdir /WebsiteOne
WORKDIR /WebsiteOne

COPY Gemfile Gemfile.lock package.json package-lock.json /WebsiteOne/
COPY scripts/copy_javascript_dependencies.js /WebsiteOne
RUN bundle install && npm install --unsafe-perm

COPY . /WebsiteOne