FROM ruby:2.5
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs qt5-default libqt5webkit5-dev gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x
RUN mkdir /WebsiteOne
WORKDIR /WebsiteOne
COPY Gemfile /WebsiteOne/Gemfile
COPY Gemfile.lock /WebsiteOne/Gemfile.lock
RUN bundle install
RUN npm install
COPY 'node_modules/nprogress/nprogress.js' \
     'node_modules/corejs-typeahead/dist/typeahead.jquery.js' \
     'node_modules/bootstrap-timepicker/js/bootstrap-timepicker.min.js' \
     'node_modules/bootstrap-datepicker/js/bootstrap-datepicker.js' \
     'node_modules/moment/min/moment.min.js' \
     'node_modules/moment-timezone/builds/moment-timezone-with-data-2010-2020.js' \
     /vendor/assets/javascripts/
COPY . /WebsiteOne
