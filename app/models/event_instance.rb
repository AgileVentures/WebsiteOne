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

  after_save :generate_twitter_tweet if :started?

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

  def generate_twitter_tweet
    if changed_attributes.include?(:hangout_url)
      tweet_hangout_notification
    end
  end

  def tweet_hangout_notification
    message = "Pair programming on Agile Ventures #{hangout_url} #pairwithme"
    begin
      tweet(message)
    rescue
      Rails.logger.error "Hangout notification tweet not sent. Please check Twitter settings."
    end
  end

end
