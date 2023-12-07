require 'rspec/core'

RSpec::configure do |c|
  c.backtrace_exclusion_patterns << /lib\/rspec\/active_model\/mocks/
end

require 'rspec/active_model/mocks/version'
require 'rspec/active_model/mocks/mocks'
