class EventInstance < ActiveRecord::Base

  include Twitterable

  belongs_to :event
  belongs_to :user
  include UserNullable
  belongs_to :project

  serialize :participants

  scope :started, -> { where.not(hangout_url: nil) }
  scope :live, -> { where('updated_at > ?', 5.minutes.ago).order('created_at DESC') }
  scope :latest, -> { order('created_at DESC') }
  scope :pp_hangouts, -> { where(category: 'PairProgramming') }

  before_save :generate_twitter_tweet

  def started?
    hangout_url?
  end

  def live?
    started? && updated_at > 5.minutes.ago
  end

  def duration
    updated_at - created_at
  end

  def self.active_hangouts
    select(&:live?)
  end

  def start_datetime
    event != nil ? event.start_datetime : created_at
  end

  private

  # before_save - hook and this one could be placed in module Twitterable
  def generate_twitter_tweet
    if changed_attributes.include?(:hangout_url)
      #tweet_hangout_notification(self)  # provided by module Twitterable
			tweet_hangout_notification
			#update_attributes(:tweeted)		 
    end
  end

	def tweet_hangout_notification
    message = "#{hangout_url}"
		puts "sdfdsff about to tweet: " << message 
    # tweet(message)
  end

end
