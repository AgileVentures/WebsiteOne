# frozen_string_literal: true

Slack.configure do |config|
  config.token = ENV.fetch('SLACK_AUTH_TOKEN', nil)
  config.logger = nil
end
