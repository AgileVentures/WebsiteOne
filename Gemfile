source 'https://rubygems.org'

gem 'rails', '4.0.2'
# PostgreSQL database support
gem 'pg'

# Sass stylesheet language
gem 'sass-rails', '~> 4.0.0'
# Javascript compressor
gem 'uglifier', '>= 1.3.0'
# Coffee-script support
gem 'coffee-rails', '~> 4.0.0'
# Google V8 javascript engine
gem 'therubyracer', platforms: :ruby
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Follow links faster
gem 'turbolinks'
# Json for declaring
gem 'jbuilder', '~> 1.2'
# Authentication local and 3rd party
gem 'devise'
# JS Bootstrap library support
gem 'bootstrap-sass', '~> 3.0.2.0'


# Use debugger
gem 'debugger', group: [:development, :test]

group :test do
  # Simulates user actions for cucumber
  gem 'capybara'
  # Cucmber features
  gem 'cucumber-rails', :require => false
  # Headless driver for capybara
  gem 'capybara-webkit'
  # Another Headless driver for capybara
  gem 'webrat'
  # Opens capybara response in your browser on save_and_open_page
  gem 'launchy'
  # Provides strategies for cleaning up the test db after test runs
  gem 'database_cleaner'
end

group :development, :test do
  #unit testing
  gem 'rspec-rails'
end

# Suggested gems:
# Provides cucumber feature scaffolds to be generated with rails generate
#  gem 'cucumber-rails-training-wheels'
# Easy creation of mocks
#  gem 'factory_girl_rails'
# Speeds up rake tasks, like rspec, cucumber, etc., by preloading rails environment
#  gem 'zeus'
# Guard support for zeus
#  gem 'guard-zeus'
# Guard support for rspec
#  gem 'guard-rspec'
# Guard support for cucumber
#  gem 'guard-cucumber'
# Guard support for livereload (reloads opened page in your browser)
#  gem 'guard-livereload'
# Patch for guard (fixes locked files issue)
#  gem "rb-readline", "~> 0.5.0"  #to fix the guard crashes