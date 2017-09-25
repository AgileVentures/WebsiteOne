module SlackService
  extend self

  def post_hangout_notification(hangout)
    return unless Features.slack.notifications.enabled
    return if hangout.hangout_url.blank?

    client = Slack::Web::Client.new
    client.chat_postMessage(channel: '', text: '', username: hangout.user.display_name, icon_url: hangout.user.gravatar_url)

    room = find_project_for_hangout(hangout.project.try(:slug))

    if hangout.category == "Scrum"
      send_slack_message client, CHANNELS.general, "@here #{req.body.title}: #{req.body.link}", hangout.user
      send_slack_message client, CHANNELS.standup_notifications, "@channel #{req.body.title}: #{req.body.link}", hangout.user

    elsif hangout.category == "PairProgramming"

      if room == CHANNELS.cs169
        console.log('sending PP event to gitter: ' + room)
        send_gitter_message_avoid_repeats room, "[#{req.body.title} with #{user.name}](#{req.body.link}) is starting NOW!"
      else
        send_slack_message client, CHANNELS.general, "#{req.body.title}: #{req.body.link}", hangout.user

        send_slack_message client, CHANNELS.pairing_notifications, "@channel #{req.body.title}: #{req.body.link}", hangout.user
        console.log('sending PP event to slack: ' + room)
      end

      # send all types of events to associated project "room" if there is one
      if room
        send_slack_message client, room, "@here #{req.body.title}: #{req.body.link}", hangout.user

      end
    end
    # uri = URI.parse "#{Slack::BOT_URL}/hubot/hangouts-notify"
    # Net::HTTP.post_form uri, {
    #   title: hangout.title,
    #   link: hangout.hangout_url,
    #   type: hangout.category,
    #   host_name: hangout.user.display_name,
    #   host_avatar: hangout.user.gravatar_url,
    #   project: hangout.project.try(:slug)
    # }

  end

  def send_slack_message(client, channel, text, user)
    client.chat_postMessage(channel: channel, text: text, username: user.display_name, icon_url: user.gravatar_url)

  end

  def send_gitter_message_avoid_repeats(room, text)

  end

  def find_project_for_hangout(project_slug)

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
