# This file is used by Rack-based servers to start the application.
require 'grape-active_model_serializers'
require ::File.expand_path('../config/environment',  __FILE__)
use Rack::Deflater
run Rails.application
