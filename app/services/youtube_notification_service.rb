require 'slack'
include ChannelsList

class YoutubeNotificationService
  def self.with(event_instance,
                slack_client = Slack::Web::Client.new(logger: Rails.logger)
               )
           new(event_instance, slack_client).send(:run)
  end

  private

  def initialize event_instance, slack_client
    @event_instance = event_instance
    @slack_client = slack_client
  end

  def run
    return unless Features.slack.notifications.enabled
    return if @event_instance.yt_video_id.blank?
    channels = channels_for_project @event_instance.project

    video = "https://youtu.be/#{@event_instance.yt_video_id}"
    @yt_message = "Video/Livestream: <#{video}|click to play>"

    send_notifications channels
  end

  def channels_for_project project 
    return [] if project.nil? or project.slug.nil?
    project.slack_channel_codes
  end

  def send_notifications channels 
    return post_premium_mob_youtube_notification if @event_instance.for == 'Premium Mob Members'
    if @event_instance.category == 'Scrum'
      send_slack_message [CHANNELS[:general]]
    elsif @event_instance.category == 'PairProgramming'
      unless channels.include? CHANNELS[:cs169]
        send_slack_message [CHANNELS[:general]]
      end
    end
    
    send_slack_message channels 
  end

  def post_premium_mob_youtube_notification
    send_slack_message [CHANNELS[:premium_extra]]
  end
  
  def send_slack_message channels
    user = @event_instance.user
    channels.each do |channel|
      unless channel.nil?
        @slack_client.chat_postMessage(channel: channel, text: @yt_message, username: user.display_name,
                                       icon_url: user.gravatar_url, link_names: 1)
      end
    end
  end 
end