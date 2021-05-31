# frozen_string_literal: true

class EventDate
  def self.for(event_date)
    if event_date.blank?
      Date.today
    else
      event_date
    end
  end
end
