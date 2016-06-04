class EventInstance < ActiveRecord::Base
  self.per_page = 30

  belongs_to :event
  belongs_to :user
  include UserNullable
  belongs_to :project

  serialize :participants

  scope :started,       -> { where.not(hangout_url: nil) }
  scope :live,          -> { where('updated_at > ?', 5.minutes.ago).order('created_at DESC') }
  scope :latest,        -> { order('created_at DESC') }
  scope :pp_hangouts,   -> { where(category: 'PairProgramming') }
  scope :recent,        -> { where('created_at BETWEEN ? AND ?', 1.days.ago.beginning_of_day, DateTime.now.end_of_day) }
  scope :oldest,        -> { order('created_at ASC') }
  scope :most_recent,   -> { latest.first }

  validate :dont_update_after_finished, on: :update

  def started?
    hangout_url?
  end

  def live?
    started? && hoa_status != 'finished' && updated_at > 2.minutes.ago
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

  def broadcaster
    self.participants.each { |_, hash| break hash['person']['displayName'] if hash['isBroadcaster'] == 'true' }
  end

  private

    def dont_update_after_finished
      self.errors.add :base, 'Can\'t update a finished event' if hoa_status_was == 'finished'
    end
end
