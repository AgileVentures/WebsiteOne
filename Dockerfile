FROM ruby:2.3.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev libqtwebkit-dev nodejs npm
RUN mkdir /app
WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install
ADD package.json /app/package.json
RUN ln /usr/bin/nodejs /usr/bin/node
RUN echo '{ "allow_root": true }' > /root/.bowerrc
RUN npm install -g bower
RUN npm install
ADD . /app