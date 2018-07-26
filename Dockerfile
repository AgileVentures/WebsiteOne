FROM ruby:2.5
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs qt5-default libqt5webkit5-dev gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x
RUN mkdir /WebsiteOne
WORKDIR /WebsiteOne
COPY Gemfile /WebsiteOne/Gemfile
COPY Gemfile.lock /WebsiteOne/Gemfile.lock
RUN bundle install
COPY . /WebsiteOne
