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

  def update_hangout_data(params)
    event = Event.find_by_id(params[:event_id])
    project = Project.find_by_id(params[:project_id])
    user = User.find_by_id(params[:host_id])

    update(title: params[:title],
           project: project,
           event: event,
           category: params[:category],
           user: user,
           participants: params[:participants],
           hangout_url: params[:hangout_url],
           yt_video_id: params[:yt_video_id])
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
