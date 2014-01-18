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
  gem 'debugger'  # Use debugger
end

group :production do
  gem 'rails_12factor'
  gem 'unicorn'
end
