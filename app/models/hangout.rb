class Hangout < ActiveRecord::Base
  belongs_to :event
  default_scope { order('created_at') }

  def started?
    hangout_url.present?
  end

  def live?
    hangout_url.present? && self.updated_at > 5.minutes.ago
  end

  def hookup?
    event.hookup?
  end

  def scrum?
    event.scrum?
  end

  def expired?
    started? && !live?
  end

  def update_hangout_data(params)
    event = Event.find_by_id(params[:event_id])
    update(title: params[:topic], event: event, category: params[:category], hangout_url: params[:hangout_url], updated_at: Time.now)
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
