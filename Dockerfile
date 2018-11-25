FROM ruby:2.5

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get update -qq && apt-get install -y build-essential \
    libpq-dev nodejs qt5-default libqt5webkit5-dev dos2unix \
    gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x

RUN mkdir /WebsiteOne
WORKDIR /WebsiteOne

COPY Gemfile Gemfile.lock package.json package-lock.json /WebsiteOne/
COPY scripts /WebsiteOne/scripts
COPY vendor/assets/javascripts /WebsiteOne/assets/javascripts
RUN dos2unix scripts/copy_javascript_dependencies.js && bundle install && \
npm install --unsafe-perm && npm install -g phantomjs-prebuilt --unsafe-perm

RUN bundle install

COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"

COPY . /WebsiteOne
