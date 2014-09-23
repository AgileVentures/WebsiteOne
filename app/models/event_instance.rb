class EventInstance < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  include UserNullable
  belongs_to :project

  serialize :participants

  scope :started, -> { where.not(hangout_url: nil) }
  scope :live, -> { where('heartbeat > ?', 5.minutes.ago).order('created_at DESC') }
  scope :latest, -> { order('created_at DESC') }
  scope :pp_hangouts, -> { where(category: 'PairProgramming') }

  def self.started_after(past_limit)
    EventInstance.where('start_planned > ?', past_limit).latest
  end

  def started?
    hangout_url?
  end

  def live?
    started? && heartbeat.present? && heartbeat > 5.minutes.ago
  end

  def duration
    heartbeat - start
  end

  def self.active_hangouts
    select(&:live?)
  end

  def start_datetime
    start || start_planned
  end

  def remove_from_template(start_time = start_planned)
    event.remove_from_schedule(start_time)
  end
end
