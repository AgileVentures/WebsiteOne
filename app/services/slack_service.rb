module SlackService
  extend self

  def post_hangout_notification(hangout)
    return unless Features.enabled?(:slack_notifications)

    uri = URI.parse "#{Slack::BOT_URL}/hubot/hangouts-notify"
    Net::HTTP.post_form uri, {
      title: hangout.title,
      link: hangout.hangout_url,
      type: hangout.category,
      host_name: hangout.user.display_name,
      host_avatar: avatar_url(hangout.user)
    }
  end

  private

  def avatar_url(user)
    hash = Digest::MD5::hexdigest(user.email.strip.downcase)
    "https://www.gravatar.com/avatar/#{hash}"
  end
end
