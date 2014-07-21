#!/usr/bin/env bash

whoami
echo ~/

sudo apt-get install -y git
sudo apt-get install -y curl

curl -sSL https://get.rvm.io | bash -s stable
source /home/vagrant/.rvm/scripts/rvm
rvm use --install 2.1.1

sudo apt-get install -y libqtwebkit-dev
gem install debugger-ruby_core_source

export LANGUAGE="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

sudo apt-get install -y libpq-dev
sudo apt-get install -y postgresql

# need to edit /etc/postgresql/9.1/main/pg_hba.conf
# needs work to handle variable white space
#
sudo sed -i -e 's/local\s\+all\s\+postgres\s\+peer/local all postgres peer map=basic/g' /etc/postgresql/9.1/main/pg_hba.conf

# need to edit /etc/postgresql/9.1/main/pg_ident.conf
echo "basic vagrant postgres" | sudo tee -a /etc/postgresql/9.1/main/pg_ident.conf

sudo /etc/init.d/postgresql restart

# this needs to run in psql
psql postgres postgres << EOF
    UPDATE pg_database SET datallowconn = TRUE where datname = 'template0';
    \c template0
    UPDATE pg_database SET datistemplate = FALSE where datname = 'template1';
    drop database template1;
    create database template1 with template = template0 encoding = 'UNICODE'  LC_CTYPE = 'en_US.UTF-8' LC_COLLATE = 'C';
    UPDATE pg_database SET datistemplate = TRUE where datname = 'template1';
    \c template1
    UPDATE pg_database SET datallowconn = FALSE where datname = 'template0';
EOF

sudo apt-get install -y xvfb
sudo apt-get install libicu48


sudo apt-get install -y python-software-properties
# How to get this command to run unattended?
sudo add-apt-repository ppa:chris-lea/node.js
sudo apt-get update
sudo apt-get install -y  nodejs

curl -L https://npmjs.org/install.sh | sudo sh

# The following script duplicates some of the above configuration, but
# adds some important Rails dependencies
# It is largely incompatible with Ubuntu 12.4 (precise) but the parts that are needed work
wget https://github.com/AgileVentures/setup-scripts/raw/develop/scripts/rails_setup.sh
HEADLESS=true WITH_PHANTOMJS=true REQUIRED_RUBY=2.1.1 source rails_setup.sh

cd /WebsiteOne

bundle install
bundle exec rake db:setup

# Cool Bash Prompt
echo 'export PS1="\[\033[32m\]\t\[\033[m\]-\[\033[31m\]\u\[\033[m\]@\[\033[36m\]\h\[\033[m\]:\[\033[33;1m\]\w\[\033[35m\]\$(__git_ps1)\[\033[37;0m\]\$ "' >> ~/.bashrc
