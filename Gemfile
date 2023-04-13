# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.2.1'

# Rather than loading the entire Rails framework, we charry pick the parts we use
gem 'actionmailer', '~> 7.0.4.3'
gem 'actionpack', '~> 7.0.4.3'
gem 'actionview', '~> 7.0.4.3'
gem 'activejob', '~> 7.0.4.3'
gem 'activemodel', '~> 7.0.4.3'
gem 'activerecord', '~> 7.0.4.3'
gem 'activestorage', '~> 7.0.4.3'
gem 'activesupport', '~> 7.0.4.3'
gem 'cssbundling-rails'
gem 'jsbundling-rails'
gem 'railties', '~> 7.0.4.3'
gem 'sprockets'
gem 'sprockets-rails'

# Gems used in production
gem 'acts_as_follower', git: 'https://github.com/AgileVentures/acts_as_follower.git'
gem 'acts-as-taggable-on'
gem 'acts_as_tree'
gem 'acts_as_votable', '~> 0.12.1'
gem 'addressable'
gem 'bootstrap-sass'
gem 'cocoon'
gem 'code_climate_badges', git: 'https://github.com/AgileVentures/codeclimate_badges'
gem 'coderay'
gem 'colored'
gem 'config'
gem 'devise', '~> 4.7'
gem 'eventmachine', '~> 1.2.7'
gem 'exception_notification'
gem 'factory_bot_rails'
gem 'faker'
gem 'font-awesome-rails'
gem 'friendly_id'
gem 'geocoder'
# gem 'ice_cube', '0.16.3'
gem 'bootsnap', '~> 1.9'
gem 'icalendar'
gem 'jbuilder'
gem 'jquery-rails'
gem 'jquery-turbolinks', '2.1.0' # Replace turbolinks: https://www.honeybadger.io/blog/hb-turbolinks-to-turbo/
gem 'jvectormap-rails', '~> 2.0'
gem 'jwt'
gem 'kaminari'
gem 'kramdown', '~> 2.1'
gem 'local_time', '~> 2.1'
gem 'mime-types', '~> 3.3', '>= 3.3.1'
gem 'nokogiri', '~> 1.14.2'
gem 'octokit'
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-google-oauth2'
gem 'omniauth-oauth2'
gem 'omniauth-rails_csrf_protection'
gem 'paper_trail', '~> 12.0'
gem 'paranoia', '~> 2.4'
gem 'paypal-sdk-rest'
gem 'pg'
gem 'pivotal-tracker-api', git: 'https://github.com/AgileVentures/pivotal-tracker-api.git'
gem 'public_activity'
gem 'puma'
gem 'rack-cache'
gem 'rack-cors', require: 'rack/cors'
gem 'rack-timeout'
gem 'rails_autolink'
gem 'recaptcha', require: 'recaptcha/rails'
gem 'redcarpet'
gem 'ruby-gitter'
gem 'sass-rails', '>= 5'
gem 'seed_dump'
gem 'slack-ruby-client'
gem 'sorted_set', '~> 1.0', '>= 1.0.3'
gem 'spinjs-rails'
gem 'stripe'
gem 'sucker_punch'
gem 'turbolinks'
gem 'utf8-cleaner'
gem 'vanity'
gem 'verbs'
gem 'will_paginate-bootstrap'
gem 'youtube_rails', '~> 1.2.3'

group :production do
  gem 'mini_racer' # for environment without pre-existing js runtimes
end

group :test do
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'cucumber-rails', require: false
  gem 'cuprite'
  gem 'database_cleaner'
  gem 'delorean' # gem is discontinued
  gem 'faraday-retry'
  gem 'launchy'
  gem 'puffing-billy'
  gem 'rails-controller-testing', '~> 1.0', '>= 1.0.2'
  gem 'rubocop-performance', '~> 1.5', '>= 1.5.2'
  gem 'rubocop-rails', '~> 2.10', '>= 2.10.1'
  gem 'rubocop-rspec', '>=1.28'
  gem 'shoulda-matchers', require: false
  gem 'stripe-ruby-mock', '~> 3.1.0.rc2', require: 'stripe_mock'
  gem 'vcr'
  gem 'webdrivers'
  gem 'webmock'
end

group :development do
  gem 'better_errors'
  gem 'derailed_benchmarks'
  gem 'letter_opener'
end

group :development, :test do
  gem 'awesome_print'
  gem 'binding_of_caller'
  gem 'brakeman', require: false
  gem 'bullet'
  gem 'bundler-audit', require: false
  gem 'constant-redefinition'
  gem 'coveralls_reborn', require: false
  gem 'dotenv-rails'
  gem 'foreman'
  gem 'guard'
  gem 'guard-cucumber'
  gem 'guard-livereload'
  gem 'guard-rspec'
  gem 'hirb'
  gem 'pry-nav'
  gem 'pry-rails'
  gem 'railroady'
  gem 'rails-erd'
  gem 'rb-readline'
  gem 'rspec-activemodel-mocks'
  gem 'rspec-html-matchers'
  gem 'rspec-rails'
  gem 'simplecov', '~> 0.17.1'
end

git_source(:github) { |repo| "https://github.com/#{repo}.git" }
gem 'ice_cube', github: 'ice-cube-ruby/ice_cube', ref: '6b97e77c106cd6662cb7292a5f59b01e4ccaedc6'
