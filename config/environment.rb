# Load the Rails application.
require File.expand_path('../application', __FILE__)
require File.expand_path('../datetime_extension', __FILE__)
require File.expand_path('../nested_key_extension', __FILE__)
require File.expand_path('../uri_validator_extension', __FILE__)
# Initialize the Rails application.
WebsiteOne::Application.initialize!
