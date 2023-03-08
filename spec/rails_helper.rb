# frozen_string_literal: true

require 'simplecov'
require 'coveralls'
SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_filter 'app/secrets'
end

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)

require 'rspec/rails'
require 'shoulda/matchers'
require 'capybara/rspec'
require 'webmock/rspec'
require 'capybara-screenshot/rspec'
require 'public_activity/testing'
require 'paper_trail/frameworks/rspec'

abort('The Rails environment is running in production mode!') if Rails.env.production?
PublicActivity.enabled = true
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
OmniAuth.config.test_mode = true
WebMock.disable_net_connect!(allow_localhost: true)
RSpec.configure do |config|
  config.fixture_path = "#{Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include Rails.application.routes.url_helpers
  config.include Capybara::DSL
  config.include FactoryBot::Syntax::Methods
  config.include Helpers
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::ControllerHelpers, type: :helper
  config.include Devise::Test::ControllerHelpers, type: :view
  config.include RSpecHtmlMatchers

  config.filter_run show_in_doc: true if ENV['APIPIE_RECORD']
  config.mock_with :rspec do |c|
    c.syntax = %i(should expect)
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
    Settings.reload!
  end

  config.after :each do
    Warden.test_reset!
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end
  config.example_status_persistence_file_path = 'tmp/rspec_failures'
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
