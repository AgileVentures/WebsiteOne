require 'slack'
require 'gitter'

class HangoutNotificationService
  def self.with(event_instance,
                slack_client = Slack::Web::Client.new(logger: Rails.logger),
                gitter_client = Gitter::Client.new(ENV['GITTER_API_TOKEN']))
          new(event_instance, slack_client, gitter_client).send(:run)
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
    GITTER_ROOMS = {
      'saasbook/MOOC': '544100afdb8155e6700cc5e4',
      'saasbook/AV102': '55e42db80fc9f982beaf2725',
      'AgileVentures/agile-bot': '56b8bdffe610378809c070cc'
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
    
    GITTER_ROOMS = {
      'saasbook/MOOC': '56b8bdffe610378809c070cc',
      'saasbook/AV102': '56b8bdffe610378809c070cc',
      'AgileVentures/agile-bot': '56b8bdffe610378809c070cc'
    }
  end
  
  private
  
  def initialize event_instance, slack_client, gitter_client
    @event_instance = event_instance
    @slack_client = slack_client
    @gitter_client = gitter_client    
  end
  
  def run
    return unless Features.slack.notifications.enabled
    return if @event_instance.hangout_url.blank?
    
    channels = channels_for_project @event_instance.project
    message = "#{@event_instance.title}: <#{@event_instance.hangout_url}|click to join>"
    @here_message = "@here #{message}"
    @channel_message = "@channel #{message}"
    
    send_notifications channels
  end
  
  def channels_for_project project
    return [] if project.nil? or project.slug.nil?
    result = CHANNELS[project.try(:slug).to_sym]
    return [result] unless result.respond_to? :each
    result
  end
  
  def send_notifications channels
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
  
  def post_pair_programming_notification channels
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
  
  def send_gitter_message_avoid_repeats message
    messages = @gitter_client.messages(GITTER_ROOMS[:'saasbook/MOOC'], limit: 50)
    return if messages.include? message
    @gitter_client.send_message(message, GITTER_ROOMS[:'saasbook/MOOC'])
  end
  
  def send_slack_message client, channels, message
    user = @event_instance.user
    channels.each do |channel|
      unless channel.nil?
        client.chat_postMessage(channel: channel, text: message, username: user.display_name,
                                icon_url: user.gravatar_url, link_names: 1)
      end
    end
  end
end