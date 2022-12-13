FROM ruby:3.0.4 as base

RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get update -qq && apt-get install -y build-essential \
    libpq-dev nodejs  \
    libqt5webkit5-dev dos2unix \
    gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x

RUN mkdir /WebsiteOne
WORKDIR /WebsiteOne

COPY Gemfile /WebsiteOne/Gemfile
COPY Gemfile.lock /WebsiteOne/Gemfile.lock

COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

#OPENSSL_CONF is set to /dev/null since not able to determine how to
#set it "correctly" for now. perhaps replace phantomjs with something else?
ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle \
    OPENSSL_CONF=/dev/null
ENV PATH="${BUNDLE_BIN}:${PATH}"

RUN bundle install

COPY package.json /WebsiteOne/package.json
#COPY package-lock.json /WebsiteOne/package-lock.json
COPY scripts /WebsiteOne/scripts
COPY vendor/assets/javascripts /WebsiteOne/assets/javascripts

FROM base

RUN dos2unix scripts/copy_javascript_dependencies.js
RUN npm install -g yarn
RUN npm install -g phantomjs-prebuilt --unsafe-perm
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \ 
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list
RUN apt-get update && apt-get -y install google-chrome-stable
RUN yarn install
COPY . /WebsiteOne
