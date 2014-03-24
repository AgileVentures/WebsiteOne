module VisitorsHelper
  def display_countdown(event)
    time_to_next_event_instance = Time.now.to_datetime.distance_to(event.next_occurrence_time.to_datetime)
    minutes_left = time_to_next_event_instance[:minutes]
    hours_left = time_to_next_event_instance[:hours]
    days_left = time_to_next_event_instance[:days]

    if days_left == 0
      "#{hours_left} hours #{minutes_left} minutes"
    else
      "#{days_left} days #{hours_left} hours #{minutes_left} minutes"
    end
  end
end
