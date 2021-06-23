# frozen_string_literal: true

# Use this file to set/override Jasmine configuration options
# You can remove it if you don't need it.
# This file is loaded *after* jasmine.yml is interpreted.
#
# Example: using a different boot file.
# Jasmine.configure do |config|
#   config.boot_dir = '/absolute/path/to/boot_dir'
#   config.boot_files = lambda { ['/absolute/path/to/boot_dir/file.js'] }
# end
#

# Without this, WebMock blocks "rake jasmine:ci" for travis
module Jasmine
  class Config
    require 'webmock'
    WebMock.disable_net_connect!(allow_localhost: true)
  end
end

# Example: prevent PhantomJS auto install, uses PhantomJS already on your path.
# Jasmine.configure do |config|
#   config.prevent_phantomjs_auto_install = true
# end
