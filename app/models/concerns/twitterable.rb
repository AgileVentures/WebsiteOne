module Twitterable

  def tweet(message)
    return unless Features.twitter.hangout_notifications.enabled = true
    check_response twitter_client.update(message)
  end

  def can_tweet?
    begin
      twitter_client.is_a? Twitter::REST::Client
    rescue
      return false
    end
  end

  # private
  # still need to figure our the public vs private thing...

  def twitter_client
    twitter_client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = ::Settings.twitter.consumer_key
      config.consumer_secret     = ::Settings.twitter.consumer_secret
      config.access_token        = ::Settings.twitter.access_token
      config.access_token_secret = ::Settings.twitter.access_token_secret
    end 
  end

  def check_response(response)
    if response.kind_of?(Twitter::Tweet)
      # we should probably change this to return the response itself, which should be 'truthy'
      true
    else
      Rails.logger.error "Twitterable: Could not update twitter status"
      false
    end
  end
end
