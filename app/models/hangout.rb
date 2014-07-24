class Hangout < ActiveRecord::Base
  belongs_to :event
  default_scope { order('created_at') }

  def started?
    hangout_url.present?
  end

  def live?
    hangout_url.present? && self.updated_at > 5.minutes.ago
  end

  def update_hangout_data(params)
    event = Event.find_by_id(params[:event_id])
    update(title: params[:topic], event: event, category: params[:category], hangout_url: params[:hangout_url], updated_at: Time.now)
  end
end
