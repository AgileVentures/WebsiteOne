WebSiteOne install
————————

:warning: These are notes from @tansaku. Use [the project setup guide](../project_setup.md) to setup your own environment. Refer to these notes if you encounter issues mentioned below where solutions are not covered in the project setup guide. :warning:

Fresh 10.11.2 (El Capitan) OSX

1) Using git for the first time prompted installing developer tools

2) pull down code

```
git clone http://github.com/AgileVentures/WebsiteOne
```

3) install gems

```
MacBook-Pro:WebsiteOne tansaku$ bundle
-bash: bundle: command not found
MacBook-Pro:WebsiteOne tansaku$ gem install bundle
Fetching: bundler-1.11.2.gem (100%)
ERROR:  While executing gem ... (Gem::FilePermissionError)
    You don't have write permissions for the /Library/Ruby/Gems/2.0.0 directory.
```

4) Searched Web

http://stackoverflow.com/questions/14607193/installing-gem-or-updating-rubygems-fails-with-permissions-error

5) Followed suggestions to install RVM

https://rvm.io/rvm/install

6) which in turn suggested install of ruby 2.2.2 (because I was in WSO dir?)

```
rvm install ruby-2.2.2
```

7) allowed me to install bundle

```
gem install bundle
```

8) then I could run bundle

```
bundle
```

9) install javascript dependencies

```
npm bower install
npm install
```

10) various fails (event machine, pg, puma) - matching what is in the [setup](../project_setup.md):

```
brew link openssl --force
```

11) fixed em and puma, but pg no - need to install postgres

http://postgresapp.com/

12) psql not yet working from command line, but that seemed to sort gem

13) capybara install failed - needed qt5: 

https://github.com/thoughtbot/capybara-webkit/wiki/Installing-Qt-and-compiling-capybara-webkit

14) more capybara issues:

```
Installing capybara-webkit 1.5.1 with native extensions

Gem::Ext::BuildError: ERROR: Failed to build gem native extension.

    /Users/tansaku/.rvm/rubies/ruby-2.2.2/bin/ruby -r ./siteconf20160225-41347-1seudkd.rb extconf.rb
Project ERROR: Xcode not set up properly. You may need to confirm the license agreement by running /usr/bin/xcodebuild.
```

install Xcode via the App Store got bundle completed

15) needed the following after db:setup

```
bin/rake db:migrate RAILS_ENV=test
```

And then we were good

