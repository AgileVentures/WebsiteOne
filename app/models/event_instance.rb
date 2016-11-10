class EventInstance < ActiveRecord::Base
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

  validate :dont_update_after_finished, on: :update

  def started?
    hangout_url?
  end

  def updated_within_last_two_minutes?
    updated_at > 2.minutes.ago
  end

  def live?
    started? && hoa_status != 'finished' && (updated_within_last_two_minutes? || manually_updated_event_not_finished?)
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

  def has_video?
    # The second check is a hack on the gem to prevent having to rescue an error.
    # I might try opening a PR to the gem itself for this
    min_plausible_vid_length = 2
    self.yt_video_id? && !!video.content_details.first && video.duration > min_plausible_vid_length
  end

  def yt_video_id=(video_id)
    super
    self.video = Yt::Video.new id: video_id
  end

  def video
    @video ||= Yt::Video.new id: yt_video_id
  end

  private

  attr_writer :video

  def manually_updated_event_not_finished?
    url_set_directly && within_current_event_duration?
  end

  def dont_update_after_finished
    if hoa_status_was == 'finished'
      self.errors.add :base, 'Can\'t update a finished event'
    end
  end
end
