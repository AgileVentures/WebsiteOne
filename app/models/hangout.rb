class Hangout < ActiveRecord::Base
  belongs_to :event

  def started?
    event_time = self.event.start_time
    hangout_url.present? && self.updated_at > 2.hours.ago
  end

  def live?
    event_time = self.event.start_time
    hangout_url.present? && self.updated_at > 15.minutes.ago
  end

  # strong parameters
  def update_hangout_data(params)
    update(title: params[:title], hangout_url: params[:hangout_url])
  end
end
