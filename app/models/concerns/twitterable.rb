module Twitterable
  #extend ActiveSupport::Concern



  # a.t.m. event_instance is in charge...
  #
  def tweet_hangout_notification(thing)
    
    raise "needs to respond to :hangout_url" unless thing.respond_to?(:hangout_url) 

    ho = thing.hangout_url
    if URI.parse(ho).scheme =~ /(^http:|^https:)/     # or should we trust the input?
      response = create_twitter_client.update(ho)
      if check_response(response)
        return true                                   # or should we raise if not true?
      else
        Rails.logger.error("could not update twitter status")
      end
    else
      Rails.logger.error("Twitter#tweet_hangout_notification - not a hangout url: #{ho}")
      raise "Not a hangout url"
    end
  end

  def tweet(message)
    response = create_twitter_client.update(message)
    check_response(response)
  end

  protected

  # just for the sake of development debugging...
  def test_setting
    puts ::Settings.twitter.consumer_key
  end


  private

  def create_twitter_client
    twitter_client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ::Settings.twitter.consumer_key
      config.consumer_secret     = ::Settings.twitter.consumer_secret
      config.access_token        = ::Settings.twitter.access_token
      config.access_token_secret = ::Settings.twitter.access_token_secret
    end 
  end

  def check_response(response)
    # we could do more with the response if it was a success...
    response.kind_of?(Twitter::Tweet) ? true : false
  end
end
