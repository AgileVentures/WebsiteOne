# frozen_string_literal: true

Yt.configure do |config|
  config.api_key = ENV['GOOGLE_PROJECT_API_KEY']
  config.log_level = :debug
end
