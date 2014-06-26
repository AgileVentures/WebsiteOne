module SlackService
  extend self

  def post_hangout_notification(hangout)
    return if Features.slack_notifications.enabled == false

    uri = URI.parse "#{Slack::BOT_URL}/hubot/hangouts-notify"
    Net::HTTP.post_form uri, {
      title: hangout.event.name,
      link: hangout.hangout_url,
      type: hangout.event.category
    }
  end
end
