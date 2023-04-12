### Installation Details: PostgreSQL

## [PostgreSQL](id:postgreSQL)



First error is usually `"role 'postgres' does not exist (PG::ConnectionBad)"`

Resolve this by running `CREATE USER postgres CREATEDB;` from the psql prompt (click the elephant icon and select "open psql" OR `createuser -s -r postgres` from command line if you have psql in your path

Another error occurs on OSX without `"host: localhost"` in the database.yml could not connect to server: No such file or directory Is the server running locally and accepting connections on Unix domain socket `"/var/pgsql_socket/.s.PGSQL.5432"`?

if psql doesn't run from the command line try: add `export PATH="/usr/local/bin:$PATH"` to your `.bash_profile `to make sure you are talking to the postgres.app that's installed rather than the non-running postgresql that comes with OSX

OSX no longer needs host: `localhost` in `database.yml` if you export PG_HOST=localhost in .bash_profile
