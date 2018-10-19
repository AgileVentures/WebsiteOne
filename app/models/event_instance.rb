class EventInstance < ApplicationRecord
  self.per_page = 30

  belongs_to :event
  delegate :within_current_event_duration?, to: :event

  belongs_to :user
  include UserNullable
  belongs_to :project

  serialize :participants

  scope :started, -> { where.not(hangout_url: nil) }
  scope :live, -> { where('updated_at > ?', 5.minutes.ago).order('created_at DESC') }
  scope :latest, -> { order('created_at DESC') }
  scope :pp_hangouts, -> { where(category: 'PairProgramming') }

  has_many :hangout_participants_snapshots
  accepts_nested_attributes_for :hangout_participants_snapshots

  def for 
    self.event.for
  end

  def self.active_hangouts
    select(&:live?)
  end

  def started?
    hangout_url?
  end

  def updated_within_last_two_minutes?
    updated_at > 2.minutes.ago
  end

  # margin: Seconds for which condition can be relaxed for start time
  def updated_within_current_event_duration?(margin)
    return false unless event.current_start_time
    updated_at > (event.current_start_time - margin) &&
      updated_at < event.current_end_time
  end

  def live?
    return false if !started? || hoa_status == 'finished'
    return true if updated_within_last_two_minutes?
    return url_set_directly && updated_within_current_event_duration?(600) &&
      event.before_current_end_time?
  end

  def duration
    updated_at - created_at
  end

  def start_datetime
    event != nil ? event.start_datetime : created_at
  end

  def broadcaster
    self.participants.each { |_, hash| break hash['person']['displayName'] if hash['isBroadcaster'] == 'true' } if self.participants
  end

  def yt_url
    yt_video_id && "https://youtu.be/#{yt_video_id}"
  end

  private

  def manually_updated_event_not_finished?
    url_set_directly && within_current_event_duration?
  end
end
