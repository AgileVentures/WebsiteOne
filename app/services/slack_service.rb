module SlackService
  extend self

  def post_hangout_notification(hangout)
    return unless Features.slack.notifications.enabled

    uri = URI.parse "#{Slack::BOT_URL}/hubot/hangouts-notify"
    Net::HTTP.post_form uri, {
      title: hangout.title,
      link: hangout.hangout_url,
      type: hangout.category,
      host_name: hangout.user.display_name,
      host_avatar: hangout.user.gravatar_url
    }
  end
end
