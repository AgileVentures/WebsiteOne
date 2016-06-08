1) Create a blank hosted workspace that clones https://github.com/AgileVentures/WebsiteOne:

![](https://www.dropbox.com/s/rrswbnz78czt8my/Screenshot%202016-05-25%2008.40.44.png?dl=1)


2) update the local software (all the linux packages on the c9 machine)

```
$ sudo apt-get update

```

3) install qtmake (cross-platform build tool) and fix any missing elements (choose Y for install):

```
$ sudo apt-get install qt5-default --fix-missing
```

4) install libqt5webkit5 (helps run our acceptance tests) (choose Y for install):

```
$ sudo apt-get install libqt5webkit5-dev
```

5) Install X virtual frame buffer (also for our acceptance tests)

```
$ sudo apt-get install xvfb
```

6) install bundler (manages all our ruby gems)

```
$ gem install bundle
```

7) install gems (note that forkbomb protection on c9 may kill bundle and you will need to re-run it several times to complete the install of all the gems)

```
$ bundle install
```

8) Configure the pre-installed postgreSQL. Check which version is installed with ls /etc/postgresql/. If the version is not 9.3, the sed commands must be edited to reflect the current version.

    # Change conf files to map your user to postgres user
    sudo sed -i 's/local[ ]*all[ ]*postgres[ ]*peer/local all postgres peer map=basic/' /etc/postgresql/9.3/main/pg_hba.conf
    sudo sed -i "$ a\basic $USER postgres" /etc/postgresql/9.3/main/pg_ident.conf
    # Start the service
    sudo service postgresql start
    # Make the default database template encoded in unicode
    psql -U postgres -c "update pg_database set encoding = 6, datcollate = 'C', datctype = 'C' where datname = 'template1';"
    sudo /etc/init.d/postgresql restart

9) initialize the db

```
$ bundle exec rake db:setup
```

10) Request the .env file
    
    ask one of the admins (e.g. @tansaku or @diraulo) for the project .env file, and also confirm which locale you are working in

11) Run the tests

    bundle exec rake spec
    bundle exec rake jasmine:ci
    bundle exec rake cucumber

Discuss any errors with the team.

12) add some seed data

    $ rake db:seed

13) Start the server

    bundle exec rails s -b $IP -p $PORT
    
14) View the running site 

    http://<c9_workspace_name>.<your_c9_user_name>.c9users.io/
