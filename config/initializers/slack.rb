# module Slack
#   BOT_URL = Settings.agile_bot_url
#   AUTH_TOKEN = ENV['SLACK_AUTH_TOKEN']
# end

Slack.configure do |config|
  config.token = ENV['PRODUCTION_SLACK_AUTH_TOKEN']
end
