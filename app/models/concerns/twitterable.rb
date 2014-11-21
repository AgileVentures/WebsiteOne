module Twitterable

  def self.tweet(message)
    check_response twitter_client.update(message)
  end

  def self.can_tweet?
    begin
      twitter_client.is_a? Twitter::REST::Client
    rescue
      return false
    end
  end

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
