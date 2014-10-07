source 'https://rubygems.org'
ruby '2.1.1'
gem 'rails', '4.1.0'
# Added after upgrade to rails 4.1
gem 'polyamorous', github: 'activerecord-hackery/polyamorous', branch: 'rails-4.1'
# End additions

gem 'puma' # Puma web server
gem 'pg'  # PostgreSQL database support
gem 'sass-rails', '~> 4.0.0' # Sass stylesheet language
gem 'uglifier'  # Javascript compressor
gem 'coffee-rails'  # Coffee-script support
gem 'therubyracer', platforms: :ruby  # Google V8 javascript engine
gem 'jquery-rails'  # Use jquery as the JavaScript library
gem 'turbolinks' # Follow links faster
gem 'jbuilder' # Json for declaring
gem 'devise' # Authentication local and 3rd party
gem 'bootstrap-sass' # JS Bootstrap library support
gem 'factory_girl_rails'
gem 'mercury-rails', github: 'jejacks0n/mercury'
gem 'faker'
gem 'omniauth'
gem 'omniauth-github', git: 'git://github.com/intridea/omniauth-github.git'
gem 'omniauth-gplus', git: 'git://github.com/samdunne/omniauth-gplus.git'
gem 'font-awesome-rails'
gem 'acts_as_tree'
gem 'acts_as_follower'
gem 'will_paginate-bootstrap'
gem 'coveralls', require: false # TODO Bryan: move to production group?
gem 'friendly_id'  # for more REST-ful routes, use human-readable IDs
gem 'colored' # colorizing console
gem 'redcarpet' # renders markdown
gem 'coderay' # syntax highlighting for markdown code blocks
gem 'acts-as-taggable-on' # Add tags to objects. Used on Projects
gem 'geocoder' # geocoding
gem 'bootstrap-modal-rails'
gem 'paper_trail'  # version control for Document
gem 'verbs'   # language and verbs - not used for now but I plan to use it in Events /Thomas
gem 'ice_cube', '0.11.1'     # used to generate event schedules, locked to last known version not to have memory leaks
gem 'jquery-turbolinks'    #fix for turbolink problem we had with the HOA button and jQuery not loading ??
gem 'addressable'       # used for uri validation
gem 'pivotal-tracker-api' # used for Pivotal Tracker API v5
gem 'exception_notification'
gem 'youtube_it' # ruby wrapper for youtube API
gem 'acts_as_votable', '~> 0.10.0' #Allows WSO to track member's votes on votable objects (articles, comments, ...)
gem 'utf8-cleaner'
gem 'public_activity' #Create activity feed

gem 'yui-compressor'
gem 'compass-rails'
gem 'rack-cache'
gem 'sprockets-image_compressor'
gem 'rack-timeout'

gem 'local_time'
gem 'rails_config' # a gem to manage configuration files
gem 'nearest_time_zone' # find the name of a timezone for a latitude and longitude without relying on a web service
gem 'octokit' # Ruby wrapper for the GitHub API
gem 'sucker_punch' # Single Process Ruby asynchronous processing library

group :test do
  gem 'capybara' # Simulates user actions for cucumber
  gem 'cucumber-rails', :require => false # Cucmber features
  gem 'capybara-webkit'  # Headless driver for capybara
  gem 'selenium-webdriver' # Headful driver for capybara
  gem 'poltergeist'  # yet another headless driver for capybara
  gem 'webrat'  # Another Headless driver for capybara
  gem 'launchy' # Opens capybara response in your browser on save_and_open_page
  gem 'database_cleaner'  # Provides strategies for cleaning up the test db after test runs
  gem 'zeus' # rails preloading environment
  gem 'webmock' # mocking external net connections
  gem 'delorean' # mocking Time in tests, aka time travelling
  gem 'vcr' # records and plays http interactions for testing
end

group :development, :test do
  gem 'rspec', '<3.0' #locking down below ver 3.0.
  gem 'rspec-activemodel-mocks'
  gem 'rspec-rails' #unit testing
  gem 'awesome_print' # plays well with pry
  gem 'pry-byebug' # a version of pry and debugger compatible with Ruby >2.0.0
  gem 'hirb' # formats ActiveRecord objects into table format in the console
  gem 'pry-rails' # integrate pry with rails console
  gem 'jasmine' # framework for testing javascript
  gem 'jasmine-jquery-rails' # framework for testing javascript
  gem 'better_errors' # nice output of rails errors in browser
  gem 'binding_of_caller'  #online console and debugging in browser
  gem 'guard' # autoruns rspec/cucumber/livereload/notify..on file change
  gem 'guard-rspec' #plugins for Guard
  gem 'guard-cucumber' #plugins for Guard
  gem 'guard-livereload' #plugins for Guard
end

group :production do
  gem 'rails_12factor'
  gem 'newrelic_rpm' # New Relic analytics
end

