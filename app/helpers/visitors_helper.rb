module VisitorsHelper
  def display_countdown(event)
    time_to_next_event_instance = seconds_to_datetime(event.next_occurrence_time.to_i - Time.now.to_datetime.to_i)
    minutes_left = time_to_next_event_instance[:minutes]
    hours_left = time_to_next_event_instance[:hours]
    days_left = time_to_next_event_instance[:days]

    if days_left == 0
      "#{hours_left} hours #{minutes_left} minutes"
    else
      "#{days_left} days #{hours_left} hours #{minutes_left} minutes"
    end
  end

  def seconds_to_datetime(s)
    mm, ss = s.divmod(60)
    hh, mm = mm.divmod(60)
    dd, hh = hh.divmod(24)
    return {:minutes=>mm, :hours=>hh, :days=>dd}
  end
end
