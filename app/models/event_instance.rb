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

  after_save :tweet_hangout_notification if :started? && :hangout_changed?

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

  # TODO need test to cover this method
  def hangout_changed?
    true if changed_attributes.include?(:hangout_url)
  end

  # need test to cover this method
  def tweet_hangout_notification
    message = "Pair programming on Agile Ventures #{hangout_url} #pairwithme"
    begin
      Twitterable.tweet(message)
    rescue
      Rails.logger.error "Hangout notification tweet not sent. Please check Twitter settings."
    end
  end

end
