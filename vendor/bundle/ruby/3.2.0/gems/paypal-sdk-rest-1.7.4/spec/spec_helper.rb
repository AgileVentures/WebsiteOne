require 'bundler/setup'

if ENV['COVERAGE']
  require 'simplecov'
  require 'coveralls'
  Coveralls.wear!
  SimpleCov.start do
    add_filter "/spec/"
  end
end

Bundler.require :default, :test
PayPal::SDK::Core::Config.load(File.expand_path('../config/paypal.yml', __FILE__), 'test')

require 'paypal-sdk-rest'

include PayPal::SDK::REST
include PayPal::SDK::Core::Logging

require 'logger'
PayPal::SDK.load('spec/config/paypal.yml', 'test')
PayPal::SDK.logger = Logger.new(STDERR)

Dir[File.expand_path("../support/**/*.rb", __FILE__)].each {|f| require f }

# Set logger for http
http_log = File.open(File.expand_path('../log/http.log', __FILE__), "w")
Payment.api.http.set_debug_output(http_log)

RSpec.configure do |config|
  config.filter_run_excluding :integration => true
  config.filter_run_excluding :disabled => true
  config.include SampleData
  # config.include PayPal::SDK::REST::DataTypes
end

WebMock.allow_net_connect!
