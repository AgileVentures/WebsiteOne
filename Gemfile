source 'https://rubygems.org'
ruby '2.3.0'
gem 'rails', '4.2.6'
# Added after upgrade to rails 4.1
gem 'polyamorous', '~> 1.2.0'
# End additions

gem 'puma' # Puma web server
gem 'pg'  # PostgreSQL database support
gem 'sass-rails' # Sass stylesheet language
gem 'uglifier'  # Javascript compressor
gem 'coffee-rails'  # Coffee-script support
gem 'therubyracer', platforms: :ruby  # Google V8 javascript engine
gem 'jquery-rails'  # Use jquery as the JavaScript library
gem 'turbolinks' # Follow links faster
gem 'jbuilder' # Json for declaring
gem 'devise', '~> 3.5.1' # Authentication local and 3rd party
gem 'bootstrap-sass' # JS Bootstrap library support
gem 'factory_girl_rails', '4.5.0'
gem 'mercury-rails', git: 'https://github.com/jejacks0n/mercury.git'
gem 'faker'
gem 'omniauth'
gem 'omniauth-oauth2', '~> 1.3.1'
gem 'omniauth-github', '~> 1.1.2'
gem 'omniauth-gplus', '~> 2.0.1'
gem 'font-awesome-rails'
gem 'acts_as_tree'
gem 'acts_as_follower'
gem 'will_paginate-bootstrap'
gem 'coveralls', require: false # measure test coverage
gem 'friendly_id' # for more REST-ful routes, use human-readable IDs
gem 'colored' # colorizing console
gem 'redcarpet' # renders markdown
gem 'coderay' # syntax highlighting for markdown code blocks
gem 'acts-as-taggable-on' # Add tags to objects. Used on Projects
gem 'geocoder' # geocoding
gem 'paper_trail', '4.0.0' # version control for Document
gem 'verbs'   # language and verbs - not used for now but I plan to use it in Events /Thomas
gem 'ice_cube', '0.11.1'     # used to generate event schedules, locked to last known version not to have memory leaks
gem 'jquery-turbolinks', '2.0.2'    #fix for turbolink problem we had with the HOA button and jQuery not loading ??
gem 'addressable'       # used for uri validation
gem 'pivotal-tracker-api', '0.1.9' # used for Pivotal Tracker API v5
gem 'exception_notification'
gem 'acts_as_votable', '~> 0.10.0' #Allows WSO to track member's votes on votable objects (articles, comments, ...)
gem 'utf8-cleaner'
gem 'public_activity' #Create activity feed
gem 'nokogiri', '~> 1.6.7.2'

gem 'yui-compressor'
gem 'compass-rails'
gem 'rack-cache'
#gem 'sprockets-image_compressor', '~> 0.2.4'
#gem 'sprockets-webp'
gem 'sprockets-rails', '2.3.3'
gem 'eventmachine', '~> 1.0.7'

gem 'local_time', '~> 1.0.3'
gem 'config' # a gem to manage configuration files
gem 'nearest_time_zone' # find the name of a timezone for a latitude and longitude without relying on a web service
gem 'octokit' # Ruby wrapper for the GitHub API
gem 'sucker_punch' # Single Process Ruby asynchronous processing library
gem 'twitter', '~> 5.11.0' # twitter api wrapper
gem 'jvectormap-rails', '~> 1.0.0' #jVectorMap for the Rails asset pipeline

gem 'active_model-errors_details'

gem 'stripe'
gem 'kaminari'


group :test do
  gem 'capybara' # Simulates user actions for cucumber
  gem 'cucumber-rails', :require => false # Cucmber features
  gem 'capybara-webkit'  # Headless driver for capybara
  gem 'selenium-webdriver' # Headful driver for capybara
  gem 'poltergeist'  # yet another headless driver for capybara
  gem 'phantomjs', :require => 'phantomjs/poltergeist'
  gem 'webrat'  # Another Headless driver for capybara
  gem 'launchy' # Opens capybara response in your browser on save_and_open_page
  gem 'database_cleaner'  # Provides strategies for cleaning up the test db after test runs
  gem 'zeus' # rails preloading environment
  gem 'webmock' # mocking external net connections
  gem 'delorean' # mocking Time in tests, aka time travelling
  gem 'vcr' # records and plays http interactions for testing
  gem 'shoulda-matchers', require: false # simplifies tests of common Rails functionality
  gem 'capybara-screenshot' # creates screenshots from capybara failures
  gem 'puffing-billy' # sandboxes network connections from javascript browser tests
end

group :development, :test do
  gem 'rspec'
  gem 'rspec-activemodel-mocks'
  gem 'rspec-rails' #unit testing
  gem 'rspec-html-matchers'
  gem 'simplecov'
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
  gem 'bullet'
  gem "brakeman", :require => false # detects security vunerabilities in rails apps
  gem "bundler-audit", :require => false # scans the Gemfile.lock and reports if there are any gems which need to be updated to fix known security issues
  gem 'constant-redefinition'
  gem 'dotenv-rails'
end

group :development, :staging, :production do
  gem 'rack-timeout'
end

group :production do
  gem 'airbrake'
  gem 'rails_12factor'
  gem 'newrelic_rpm' # New Relic analytics
end

gem 'code_climate_badges', git: 'https://github.com/AgileVentures/codeclimate_badges'
