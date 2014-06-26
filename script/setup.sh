#!/usr/bin/env bash
#
# run this script using:
#   source ./script/setup.sh
#
#
# current supported platforms:
#
#   Ubuntu 14.04
#
#
# references:
#
#   https://gorails.com/setup/ubuntu/14.04
#

REQUIRED_RUBY=2.1.1 GEMSET=WebsiteOne WITH_PHANTOMJS=true source <(\
  \curl -sSL https://raw.githubusercontent.com/AgileVentures/setup-scripts/master/scripts/rails_setup.sh)

if [[ $? = 0 ]]; then
echo "
################### Post-install Message ##########################
  Run these commands to check if everything is working:

    bundle exec rspec
    bundle exec cucumber


  wait a few minutes, if no errors crop up, you are all set up! To
  see the site running locally, run:

    rails server


  now open a browser and visit http://localhost:3000. You should see
  the site running, go nuts!
"
fi
