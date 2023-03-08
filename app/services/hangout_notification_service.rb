# frozen_string_literal: true

require 'slack'
require 'gitter'
include ChannelsList

class HangoutNotificationService
  def self.with(event_instance,
                slack_client = Slack::Web::Client.new(logger: Rails.logger),
                gitter_client = Gitter::Client.new(ENV.fetch('GITTER_API_TOKEN', nil)))
    new(event_instance, slack_client, gitter_client).send(:run)
  end

  private

  def initialize(event_instance, slack_client, gitter_client)
    @event_instance = event_instance
    @slack_client = slack_client
    @gitter_client = gitter_client
  end

  def run
    return unless Features.slack.notifications.enabled
    return if @event_instance.hangout_url.blank?

    channels = channels_for_project @event_instance.project
    channels += @event_instance.channels_for_event
    message = "#{@event_instance.title}: <#{@event_instance.hangout_url}|click to join>"
    @here_message = "@here #{message}"
    @channel_message = "@channel #{message}"

    send_notifications channels
  end

  def channels_for_project(project)
    return [] if project.nil? || project.slug.nil?

    project.slack_channel_codes
  end

  def send_notifications(channels)
    return post_premium_mob_hangout_notification if @event_instance.for == 'Premium Mob Members'

    case @event_instance.category
    when 'Scrum'
      post_scrum_notification
    when 'PairProgramming'
      post_pair_programming_notification channels
    end

    # # send all types of events to associated project 'channel' if there is one
    send_slack_message @slack_client, channels, @here_message
  end

  def post_premium_mob_hangout_notification
    send_slack_message @slack_client, [CHANNELS[:premium_extra],
                                       CHANNELS[:premium_mob_trialists]], @here_message
  end

  def post_scrum_notification
    send_slack_message @slack_client, [CHANNELS[:general]], @here_message
    send_slack_message @slack_client, [CHANNELS[:standup_notifications]],
                       @channel_message
  end

  def post_pair_programming_notification(channels)
    if channels.include? CHANNELS[:cs169]
      message = "[#{@event_instance.title} with #{@event_instance.user.display_name}](#{@event_instance.hangout_url})"
      message << ' is starting NOW!'
      send_gitter_message_avoid_repeats message
    else
      send_slack_message @slack_client, [CHANNELS[:general]], @here_message
    end
    send_slack_message @slack_client, [CHANNELS[:pairing_notifications]],
                       @channel_message
  end

  def send_gitter_message_avoid_repeats(message)
    messages = @gitter_client.messages(GITTER_ROOMS[:'saasbook/MOOC'], limit: 50)
    return if messages.include? message

    @gitter_client.send_message(message, GITTER_ROOMS[:'saasbook/MOOC'])
  end

  def send_slack_message(client, channels, message)
    user = @event_instance.user
    channels.each do |channel|
      unless channel.nil?
        client.chat_postMessage(channel: channel, text: message, username: user.display_name,
                                icon_url: user.gravatar_url, link_names: 1)
      end
    end
  end
end
