class EventInstance < ActiveRecord::Base
  self.per_page = 30

  belongs_to :event
  belongs_to :user
  include UserNullable
  belongs_to :project

  serialize :participants

  scope :started, -> { where.not(hangout_url: nil) }
  scope :live, -> { where('updated_at > ?', 5.minutes.ago).order('created_at DESC') }
  scope :latest, -> { order('created_at DESC') }
  scope :pp_hangouts, -> { where(category: 'PairProgramming') }

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
    if hoa_status_was == 'finished'
      self.errors.add :base, "Can't update a finished event"
    end
  end
end
