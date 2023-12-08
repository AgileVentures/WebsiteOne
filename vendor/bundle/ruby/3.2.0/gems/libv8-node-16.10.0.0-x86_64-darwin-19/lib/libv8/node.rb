require 'libv8/node/version'
require 'libv8-node/location'

module Libv8; end

module Libv8::Node
  def self.configure_makefile
    location = Location.load!
    location.configure
  end
end
