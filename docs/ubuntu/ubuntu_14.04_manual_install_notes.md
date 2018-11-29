Manual Installation steps for Ubuntu 14.04 LTS
==============================================

These set of instructions are a bit opinionated but they do work just fine and can be used if rails installation script doesn't work for the project. The setup is tested against Ubuntu 14.04 LTS 64-bit OS version.

# Steps
Assuming a fresh ubuntu installation, please follow the instructions in given order

## Update and upgrade packages
```
sudo apt-get update
sudo apt-get upgrade
```

## Install nvm (node version manager)
```
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh | bash
```

## Install latest version of nodejs
```
nvm install 5.10.1
nvm use 5.10.1
```

## Install phantomjs npm package
```
npm install -g phantomjs
```

Remember to run `nvm use ..` before you start any work. Unfortunately there is no workaround. There is option for .nvmrc file but it  won't work like rvm config files.

## Install git (Version Control)
```
sudo apt-get install git
```

## Install postgres and other packages
```
sudo apt-get install curl bundler postgresql-common postgresql-9.3 libpq-dev libgdbm-dev libncurses5-dev automake libtool bison libffi-dev libqtwebkit-dev
```

> If you have trouble installing PostgreSQL, read more at [Official PostgreSQL Website](https://www.postgresql.org/download/linux/ubuntu/)

## Install xvfb (Virtual frame buffer implementing X11 display server protocol)
```
sudo apt-get install xvfb
```
This will be useful for running rspec tests from a remote terminal(or cloud based dev environment like aws) which will fail otherwise in absence of a display system. Instructions on how to run rspec tests using xvfb will be explained below.

## Install rvm (Ruby version manager)
```
\curl -sSL https://get.rvm.io | bash -s stable --ruby --auto-dotfiles
source ~/.rvm/scripts/rvm
```

## Install ruby
```
rvm install ruby-2.5.1
```

## Clone the respository (after a fork)
```
git clone git@github.com:<your github handle>/WebsiteOne.git
```

## Generate rvm config files within project
```
rvm use ruby-2.5.1@WebsiteOne --ruby-version --create
```

## Install bundler
Just to be safe, install bundle gem first. Otherwise `bundle install` may fail.
```
gem install bundler
```

## Install all gems
```
bundle install
```

## Install all javascript dependencies
```
npm install bower
npm install
```

## Database config changes
Postgres database is intially in **peer** authentication mode. Change it to **trust** mode for **postgres** user

```
sudo vim /etc/postgresql/9.3/main/pg_hba.conf
```

Find postgres user and change its authentication mode from peer to trust. Save and close.

## Restart the database
```
sudo /etc/init.d/postgresql restart
```

## Test database login
You should be able to see `postgres=#` prompt after executing following command
```
psql -U postgres
```
enter `\q` or press CTRL + D for exit from prompt.

## Prepare database
```
bundle exec rake db:create:all
bundle exec rake db:setup
bundle exec rake db:test:prepare
```

you may get a warning saying `db:test:prepare is deprecated. The Rails test helper now maintains your test schema automatically, see the release notes for details.` which is normal.


## Request .env file from admins
ask one of the admins (e.g. @tansaku or @diraulo) for the project .env file, and also confirm which locale you are working in.

## Check test runs
rspec
```
bundle exec rspec
```
jasmine
```
bundle exec rake jasmine:ci
```
cucumber
```
bundle exec rake cucumber
```

In case of remote machine (like aws), few rspec tests may fail due to absence of display system. To avoid those erros, use **xvfb**
```
xvfb-run -a bundle exec rspec
```


## Start the server
```
bundle exec rails s
```
