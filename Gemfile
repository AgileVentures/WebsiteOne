source 'https://rubygems.org'

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
gem 'debugger', group: [:development, :test] # Use debugger

group :test do
  gem 'capybara' # Simulates user actions for cucumber
  gem 'cucumber-rails', :require => false # Cucmber features
  gem 'capybara-webkit'  # Headless driver for capybara
  gem 'selenium-webdriver'
  gem 'webrat'  # Another Headless driver for capybara
  gem 'launchy' # Opens capybara response in your browser on save_and_open_page
  gem 'database_cleaner'  # Provides strategies for cleaning up the test db after test runs
  gem 'zeus'
end

group :development, :test do
  gem 'rspec-rails' #unit testing
end

# Suggested gems:
# Provides cucumber feature scaffolds to be generated with rails generate
#  gem 'cucumber-rails-training-wheels'
# Easy creation of mocks
#  gem 'factory_girl_rails'
## Speeds up rake tasks, like rspec, cucumber, etc., by preloading rails environment
#  gem 'zeus'
## Guard support for zeus
#  gem 'guard-zeus'
## Guard support for rspec
#  gem 'guard-rspec'
## Guard support for cucumber
#  gem 'guard-cucumber'
## Guard support for livereload (reloads opened page in your browser)
#  gem 'guard-livereload'
## Patch for guard (fixes locked files issue)
#  gem "rb-readline", "~> 0.5.0", :require => false  #to fix the guard crashes
