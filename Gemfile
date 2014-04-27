source 'https://rubygems.org'
ruby '2.1.1'
gem 'rails', '4.1.0'
# Added after upgrade to rails 4.1
gem 'polyamorous', github: 'activerecord-hackery/polyamorous', branch: 'rails-4.1'
# End additions

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
gem 'google-analytics-rails'
gem 'friendly_id'  # for more REST-ful routes, use human-readable IDs
gem 'colored' # colorizing console
gem 'redcarpet' # renders markdown
gem 'coderay' # syntax highlighting for markdown code blocks
gem 'acts-as-taggable-on' # Add tags to objects. Used on Projects
gem 'geocoder' # geocoding
gem 'bootstrap-modal-rails'
gem 'paper_trail'  # version control for Document
gem 'verbs'   # language and verbs - not used for now but I plan to use it in Events /Thomas
gem 'ice_cube'     # used for Event
gem 'jquery-turbolinks'    #fix for turbolink problem we had with the HOA button and jQuery not loading ??
gem 'addressable'       # used for uri validation
gem 'pivotal-tracker-api' # used for Pivotal Tracker API v5
gem 'exception_notification'

gem 'yui-compressor'
gem 'compass-rails'
gem 'rack-cache'
gem 'sprockets-image_compressor'

group :test do
  gem 'capybara' # Simulates user actions for cucumber
  gem 'cucumber-rails', :require => false # Cucmber features
  gem 'capybara-webkit'  # Headless driver for capybara
  gem 'selenium-webdriver' # Headful driver for capybara
  gem 'poltergeist'  # yet another headless driver for capybara
  gem 'webrat'  # Another Headless driver for capybara
  gem 'launchy' # Opens capybara response in your browser on save_and_open_page
  gem 'database_cleaner'  # Provides strategies for cleaning up the test db after test runs
  gem 'zeus', '0.13.4.pre2' # rails preloading environment (the only ver that works with RubyMine)
  gem 'webmock' # mocking external net connections
  gem 'delorean'
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
