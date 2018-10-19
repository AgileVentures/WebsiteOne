1) Create a blank hosted workspace that clones https://github.com/AgileVentures/WebsiteOne:

![](images/Screenshot%202016-05-25%2008.40.44.png)

1a) install ruby 2.5.1

```
$ rvm install 2.5.1
```

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
$ gem install bundler
```

7) install gems (note that forkbomb protection on c9 may kill bundle and you will need to re-run it several times to complete the install of all the gems)

```
$ bundle install --without production
```

8) install javascript dependencies (ensure bower is installed `npm install bower`)

```
$ npm install
```

9) Configure the pre-installed postgreSQL. Check which version is installed with `ls /etc/postgresql/`. If the version is not 9.3, the sed commands must be edited to reflect the current version.

```
# Change conf files to map your user to postgres user
$ sudo sed -i 's/local[ ]*all[ ]*postgres[ ]*peer/local all postgres peer map=basic/' /etc/postgresql/9.3/main/pg_hba.conf
$ sudo sed -i "$ a\basic $USER postgres" /etc/postgresql/9.3/main/pg_ident.conf
```

- Then start postgres

```
# Start the service
$ sudo service postgresql start
```
- Set encoding

```
# Make the default database template encoded in unicode
$ psql -U postgres -c "update pg_database set encoding = 6, datcollate = 'C', datctype = 'C' where datname = 'template1';"
$ sudo /etc/init.d/postgresql restart
```

- If the following error occurs when setting the encoding

```
psql: FATAL:  Peer authentication failed for user "postgres"
```

- Then login into postgres by typing `psql` at the command line

```
$ psql
```

- And follow the [stackoverflow](https://stackoverflow.com/a/16737776/10166730) fix.
- Also for easy reference the commands are listed below.

```
UPDATE pg_database SET datistemplate = FALSE WHERE datname = 'template1';
DROP DATABASE template1;
CREATE DATABASE template1 WITH TEMPLATE = template0 ENCODING = 'UNICODE';
UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template1';
\c template1
VACUUM FREEZE;
```

- Then exit postgres

```
\q
```

10) initialize the db

```
$ bundle exec rake db:create db:migrate db:setup
```

11) Request the .env file

Ask one of the admins (e.g. @tansaku or @diraulo) for the project .env file, and also confirm which locale you are working in.

Assuming your locale is `en_US.UTF-8` do the following:

Run in terminal:

```
sudo locale-gen en_US.UTF-8
```

Then:

```
c9 ~/.bashrc
```

After `. /etc/apache2/envvars` add these lines:

```
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
```

**Note**: If you face the error `Fontconfig warning: ignoring C.UTF-8: not a valid language tag`, then your locale is not correctly set.

12) Run the tests

**Note** to run the tests we need to ensure the test database has been migrated, use `bin/rake db:migrate RAILS_ENV=test`

```
$ xvfb-run -a bundle exec rake spec
$ bundle exec rake jasmine:ci
$ bundle exec rake cucumber
```

If you get timeouts in running cucumber. They start with `Timed out waiting for response to`, you may increase the value explicitly in `features/support/capybara.rb`:
```
test_options = {
    phantomjs_options: [
        '--ignore-ssl-errors=yes',
        "--proxy=#{Billy.proxy.host}:#{Billy.proxy.port}"
    ],
    timeout: 500,
    phantomjs: Phantomjs.path,
    js_errors: true,
}
```

Discuss any errors with the team.

13) add some seed data

```
$ rake db:seed
```

14) Start the server

```
$ bundle exec rails s -b $IP -p $PORT
```

15) View the running site

Click on `Share` on top right corner. The url in front of `Application` is the one which you can use to view your site.


**Note**

Each time you come back to c9 you may need to restart the database:

```
sudo service postgresql start
```
