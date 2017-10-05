require 'slack'
require 'gitter'

module SlackService
  extend self

  def post_hangout_notification(hangout,
                                slack_client = Slack::Web::Client.new(logger: Rails.logger),
                                gitter_client = Gitter::Client.new(ENV['GITTER_API_TOKEN']))

    return unless Features.slack.notifications.enabled
    return if hangout.hangout_url.blank?

    channel = channel_for_project(hangout.project)

    if hangout.category == "Scrum"
      send_slack_message slack_client, CHANNELS[:general], "@here #{hangout.title}: #{hangout.hangout_url}", hangout.user
      send_slack_message slack_client, CHANNELS[:standup_notifications], "@channel #{hangout.title}: #{hangout.hangout_url}", hangout.user

    elsif hangout.category == "PairProgramming"

      if channel == CHANNELS[:cs169]
        # puts("sending PP event to gitter: #{channel}")
        send_gitter_message_avoid_repeats gitter_client, "[#{hangout.title} with #{hangout.user.display_name}](#{hangout.hangout_url}) is starting NOW!"
      else
        send_slack_message slack_client, CHANNELS[:general], "@here #{hangout.title}: #{hangout.hangout_url}", hangout.user
        # puts("sending PP event to slack: #{channel}")
      end
      send_slack_message slack_client, CHANNELS[:pairing_notifications], "@channel #{hangout.title}: #{hangout.hangout_url}", hangout.user
    end
    # send all types of events to associated project "channel" if there is one
    if channel
      send_slack_message slack_client, channel, "@here #{hangout.title}: #{hangout.hangout_url}", hangout.user
    end
  end

  def send_slack_message(client, channel, text, user)
    client.chat_postMessage(channel: channel, text: text, username: user.display_name, icon_url: user.gravatar_url, link_names: 1)
  end

  def send_gitter_message_avoid_repeats(gitter_client, text)
    messages = gitter_client.messages(GITTER_ROOMS[:'saasbook/MOOC'], limit: 50)
    return if messages.include? text

    gitter_client.send_message(text, GITTER_ROOMS[:'saasbook/MOOC'])
  end

  def channel_for_project(project)
    return nil if project.nil? or project.slug.nil?
    CHANNELS[project.try(:slug).to_sym]
  end

  def post_yt_link(hangout, client = Slack::Web::Client.new(logger: Rails.logger))
    return unless Features.slack.notifications.enabled
    return if hangout.yt_video_id.blank?

    channel = channel_for_project(hangout.project)

    video = "https://youtu.be/#{hangout.yt_video_id}"

    if hangout.category == "Scrum"
      send_slack_message client, CHANNELS[:general], "Video/Livestream for #{hangout.title}: #{video}", hangout.user
    elsif hangout.category == "PairProgramming"
      channel = channel_for_project(hangout.project)
      unless channel == CHANNELS[:cs169]
        send_slack_message client, CHANNELS[:general], "Video/Livestream for #{hangout.title}: #{video}", hangout.user
        send_slack_message client, channel, "Video/Livestream for #{hangout.title}: #{video}", hangout.user
      end
    end

  end

  if ENV['LIVE_ENV'] == 'production'
    CHANNELS = {
        "asyncvoter": "C2HGJF54G",
        "autograder": "C0UFNHRAB",
        "betasaasers": "C02AHEA5P",
        "binghamton-university-bike-share": "C033Z02P9",
        "codealia": "C0297TUQC",
        "communityportal": "C02HVF1TP",
        "cs169": "C02A6835V",
        "dda-pallet": "C2QM5N48P",
        "educhat": "C02AD0LG0",
        "esaas-mooc": "C02A6835V",
        "eventmanager": "C39J4DTP0",
        "metplus": "C09LSBWER",
        "localsupport": "C0KK907B5",
        "osra-support-system": "C02AAM8SY",
        "github-api-gem": "C02QZ46S9",
        "oodls": "C03GBBASJ",
        "projectscope": "C1NJX7KM1",
        "redeemify": "C1FQZHJJX",
        "refugee_tech": "C0GUTH7RS",
        "secondappinion": "C03D6RUR7",
        "shf-project": "C2SBUUNRY",
        "snow-angels": "C03D6RUR7",
        "takemeaway": "C04B0TN0S",
        "teamaidz": "C03DA8NH0",
        "visualizer": "C3NE9JQJX",
        "websiteone": "C029E8G80",
        "websitetwo": "C0ASA1X98",
        "wiki-ed-dashboard": "C36MNPWTD",
        "general": "C0285CSUF",
        "pairing_notifications": "C02BNVCM1",
        "standup_notifications": "C02B4QH1C"
    }
    GITTER_ROOMS = {
        "saasbook/MOOC": "544100afdb8155e6700cc5e4",
        "saasbook/AV102": "55e42db80fc9f982beaf2725",
        "AgileVentures/agile-bot": "56b8bdffe610378809c070cc"
    }
  else
    CHANNELS =    {
        "cs169": "C29J4CYA2",
        "websiteone": "C29J4QQ9W",
        "general": "C0TLAE1MH",
        "pairing_notifications": "C29J3DPGW",
        "standup_notifications": "C29JE6HGR",
    }

    GITTER_ROOMS = {
        "saasbook/MOOC": "56b8bdffe610378809c070cc",
        "saasbook/AV102": "56b8bdffe610378809c070cc",
        "AgileVentures/agile-bot": "56b8bdffe610378809c070cc"
    }
  end
end
