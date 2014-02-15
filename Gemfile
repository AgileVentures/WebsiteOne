source 'https://rubygems.org'
ruby '2.0.0'
gem 'rails', '4.0.2'
gem 'pg'  # PostgreSQL database support
gem 'sass-rails', '~> 4.0.0' # Sass stylesheet language
gem 'uglifier', '>= 1.3.0'   # Javascript compressor
gem 'coffee-rails', '~> 4.0.0'  # Coffee-script support
gem 'therubyracer', platforms: :ruby  # Google V8 javascript engine
gem 'jquery-rails'  # Use jquery as the JavaScript library
gem 'turbolinks' # Follow links faster
gem 'jbuilder', '~> 1.2' # Json for declaring
gem 'devise' # Authentication local and 3rd party
gem 'bootstrap-sass', '~> 3.0.2.0' # JS Bootstrap library support
gem 'factory_girl_rails'
gem 'mercury-rails', github: 'jejacks0n/mercury'
gem 'faker'
gem 'omniauth'
gem 'omniauth-github', git: 'git://github.com/intridea/omniauth-github.git'
gem 'omniauth-gplus', git: 'git://github.com/samdunne/omniauth-gplus.git'
gem 'font-awesome-rails'
gem 'high_voltage'
gem 'acts_as_tree', '~> 1.5.0'
gem 'acts_as_follower'
gem 'will_paginate-bootstrap'
gem 'coveralls', require: false # TODO Bryan: move to production group?
gem 'google-analytics-rails'
gem 'friendly_id', '~> 5.0.0' # Bryan: for more REST-ful routes, use human-readable IDs
gem 'colored' # colorizing console
gem 'acts-as-taggable-on'

group :test do
  gem 'capybara' # Simulates user actions for cucumber
  gem 'cucumber-rails', :require => false # Cucmber features
  gem 'capybara-webkit'  # Headless driver for capybara
  gem 'selenium-webdriver' # Headful driver for capybara
  gem 'webrat'  # Another Headless driver for capybara
  gem 'launchy' # Opens capybara response in your browser on save_and_open_page
  gem 'database_cleaner'  # Provides strategies for cleaning up the test db after test runs
  gem 'zeus', '0.13.4.pre2' # rails preloading environment (the only ver that works with RubyMine)
  gem 'webmock' # mocking external net connections
end

group :development, :test do
  gem 'rspec-rails' #unit testing
#TODO YA do we need it? It breaks Rubymine's debugging
  gem 'debugger'  # Use debugger
  gem 'jasmine' # framework for testing javascript
  gem 'jasmine-jquery-rails' # framework for testing javascript
  gem 'better_errors' # nice output of rails errors in browser
  gem 'binding_of_caller'  #online console and debugging in browser
end

group :production do
  gem 'rails_12factor'
  gem 'unicorn'
end
