class Hangout < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  belongs_to :project

  serialize :participants

  def started?
    hangout_url.present?
  end

  def live?
    hangout_url.present? && self.updated_at > 5.minutes.ago
  end

  def hookup?
    category == "PairProgramming"
  end

  def expired?
    started? && !live?
  end

  def self.active_hangouts
    select(&:live?)
  end

  def self.live
    where('hangouts.updated_at > :five_minutes_ago', five_minutes_ago: 5.minutes.ago.to_datetime)
  end

  def self.started
    where.not(hangout_url: nil)
  end

  def self.pp_hangouts
    where(category: "PairProgramming")
  end

  def start_datetime
    event != nil ? event.start_datetime : created_at
  end

end
