module TwitterService

  def self.tweet(message)
    if Settings.features.twitter.notifications.enabled == true
      check_response twitter_client.update(message)
    else
      false
    end
  end

  private

  def self.twitter_client
    @twitter_client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = Settings.twitter.consumer_key
      config.consumer_secret     = Settings.twitter.consumer_secret
      config.access_token        = Settings.twitter.access_token
      config.access_token_secret = Settings.twitter.access_token_secret
    end
  end

  def self.check_response(response)
    if response.kind_of?(Twitter::Tweet)
      true
    else
      Rails.logger.error "Twitterable: Could not update twitter status"
      false
    end
  end
end
