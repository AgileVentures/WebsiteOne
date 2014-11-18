#!/usr/bin/env bash
#
# big thanks to Paul who wrote the original script:
#
#   https://gist.github.com/apelade/8203553
#
#
# run this script using:
#   source ./scripts/rails_setup.sh
#
#
# tested on these platforms:
#
#   Ubuntu 14.04
#   OS X Mavericks
#
#
# references:
#
#   https://gorails.com/setup/ubuntu/14.04
#


echo "
####################### AgileVentures #############################

  This script sets up the environment for a basic Rails
  application. Grab a drink, this could take a while.


  Want to find out more about what this does, checkout the repo:

    https://github.com/AgileVentures/setup-scripts


  Hit ENTER to continue
"
read -s


echo "
####################### DEPENDENCIES ##############################
"
if [ $(uname) = "Linux" ]; then
  sudo apt-get update
  sudo apt-get install curl bundler postgresql-common postgresql-9.3 libpq-dev \
    libgdbm-dev libncurses5-dev automake libtool bison libffi-dev \
    libqtwebkit-dev nodejs nodejs-legacy npm
  if [ -n "$HEADLESS" ]; then
      sudo apt-get install -y xvfb
  fi

elif [ $(uname) = "Darwin" ]; then
  if ! hash brew 2>/dev/null; then
    ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
  fi

  brew update
  brew doctor
  brew install qt
  brew install postgresql
  brew install node
fi

if [ -n "$WITH_PHANTOMJS" ]; then
  sudo npm install -g phantomjs
fi


echo "
########################### Ruby ##################################
"
if hash rvm 2>/dev/null; then
  rvm get stable
else
  \curl -sSL https://get.rvm.io | bash -s stable --ruby --auto-dotfiles
  source ~/.rvm/scripts/rvm
fi
echo

if [ -n "$REQUIRED_RUBY" ]; then
  if ! rvm list | grep $REQUIRED_RUBY; then
    echo "Installing ruby-$REQUIRED_RUBY"
    rvm install $REQUIRED_RUBY
    rvm use $REQUIRED_RUBY
  else
    rvm use $REQUIRED_RUBY
  fi
  ruby -v
  echo

  if [ -n $GEMSET ]; then
    if ! rvm gemset list | grep $GEMSET; then
      echo "Creating a new gemset $REQUIRED_RUBY@$GEMSET"
      rvm gemset create $GEMSET
      echo "ruby-$REQUIRED_RUBY" > .ruby-version
      echo "$GEMSET" > .ruby-gemset
      rvm use $REQUIRED_RUBY@$GEMSET
    else
      echo "Detected gemset ruby-$REQUIRED_RUBY@$GEMSET"
      rvm use $REQUIRED_RUBY@$GEMSET
    fi
    echo
  fi
fi

if [ -z $SKIP_BUNDLE ]; then
  bundle install
fi

if [ -z $SKIP_MIGRATIONS ]; then
  echo "Running migrations"
  bundle exec rake db:create:all
  bundle exec rake db:setup
  bundle exec rake db:test:prepare
fi
