require 'slack'

class YoutubeNotificationService
  def self.with(event_instance,
                slack_client = Slack::Web::Client.new(logger: Rails.logger)
               )
           new(event_instance, slack_client).send(:run)
  end
  if ENV['LIVE_ENV'] == 'production'
    CHANNELS = {
      'asyncvoter': 'C2HGJF54G',
      'autograder': ['C0UFNHRAB','C02AHEA5P'],
      'betasaasers': 'C02AHEA5P',
      'binghamton-university-bike-share': 'C033Z02P9',
      'codealia': 'C0297TUQC',
      'communityportal': 'C02HVF1TP',
      'cs169': 'C02A6835V',
      'dda-pallet': 'C2QM5N48P',
      'educhat': 'C02AD0LG0',
      'esaas-mooc': 'C02A6835V',
      'eventmanager': 'C39J4DTP0',
      'agileventures-community': ['C3Q9A5ZJA', 'C02P3CAPA'],
      'metplus': 'C0VEPAPJP',
      'localsupport': 'C0KK907B5',
      'osra-support-system': 'C02AAM8SY',
      'github-api-gem': 'C02QZ46S9',
      'oodls': 'C03GBBASJ',
      'phoenixone': 'C7JANJXC4',
      'projectscope': 'C1NJX7KM1',
      'redeemify': 'C1FQZHJJX',
      'refugee_tech': 'C0GUTH7RS',
      'rundfunk-mitbestimmen': 'C5LCQSJMA',
      'secondappinion': 'C03D6RUR7',
      'shf-project': 'C2SBUUNRY',
      'snow-angels': 'C03D6RUR7',
      'takemeaway': 'C04B0TN0S',
      'teamaidz': 'C03DA8NH0',
      'visualizer': 'C3NE9JQJX',
      'websiteone': 'C029E8G80',
      'websitetwo': 'C0ASA1X98',
      'wiki-ed-dashboard': 'C36MNPWTD',
      'general': 'C0285CSUF',
      'pairing_notifications': 'C02BNVCM1',
      'standup_notifications': 'C02B4QH1C',
      'premium_mob_trialists': 'GBNRMP4KH',
      'premium_extra': 'G33RPEG8K'
    } 
  else
    CHANNELS =    {
      'multiple-channels': ['C69J9GC1Y', 'C29J4QQ9W'],
      'cs169': 'C29J4CYA2',
      'websiteone': 'C29J4QQ9W',
      'localsupport': 'C69J9GC1Y',
      'general': 'C0TLAE1MH',
      'pairing_notifications': 'C29J3DPGW',
      'standup_notifications': 'C29JE6HGR',
      'premium_extra': 'C29J4QQ9M',
      'premium_mob_trialists': 'C29J4QQ9F'
    }
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
    result = CHANNELS[project.try(:slug).to_sym]
    return [result] unless result.respond_to? :each
    result
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