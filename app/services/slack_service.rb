module SlackService
  extend self

  def post_hangout_notification(hangout)
    return unless Features.slack.notifications.enabled
    return if hangout.hangout_url.blank?

    uri = URI.parse "#{Slack::BOT_URL}/hubot/hangouts-notify"
    Net::HTTP.post_form uri, {
      title: hangout.title,
      link: hangout.hangout_url,
      type: hangout.category,
      host_name: hangout.user.display_name,
      host_avatar: hangout.user.gravatar_url,
      project: hangout.project.try(:slug)
    }
  end

  def post_yt_link(hangout)
    return unless Features.slack.notifications.enabled
    return if hangout.yt_video_id.blank?

    uri = URI.parse "#{Slack::BOT_URL}/hubot/hangouts-video-notify"
    Net::HTTP.post_form uri, {
      title: hangout.title,
      video: "https://youtu.be/#{hangout.yt_video_id}",
      type: hangout.category,
      host_name: hangout.user.display_name,
      host_avatar: hangout.user.gravatar_url,
      project: hangout.project.try(:slug)
    }
  end
end
