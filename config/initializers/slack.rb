Slack.configure do |config|
  config.token = ENV['SLACK_AUTH_TOKEN']
  config.logger = nil
end
