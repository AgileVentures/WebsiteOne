# frozen_string_literal: true

class EventDate
  def self.for(event_date)
    (event_date.presence || Date.today)
  end
end
