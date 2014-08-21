class Hangout < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  belongs_to :project

  serialize :participants

  scope :started, -> { where.not(hangout_url: nil) }
  scope :live, -> { where('updated_at > ?', 5.minutes.ago) }
  scope :pp_hangouts, -> { where(category: 'PairProgramming') }

  def started?
    hangout_url?
  end

  def live?
    started? && updated_at > 5.minutes.ago
  end

  def self.active_hangouts
    select(&:live?)
  end

  def start_datetime
    event != nil ? event.start_datetime : created_at
  end

end
