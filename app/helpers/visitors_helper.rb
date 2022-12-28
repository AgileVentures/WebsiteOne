# frozen_string_literal: true

module VisitorsHelper
  def display_countdown(event)
    time_to_next_event_instance = Time.now.to_datetime.distance_to(event.next_occurrence_time_attr.to_datetime)
    minutes_left = time_to_next_event_instance[:minutes]
    hours_left = time_to_next_event_instance[:hours]
    days_left = time_to_next_event_instance[:days]

    if days_left.zero? && hours_left.zero?
      pluralize(minutes_left, 'minute')
    elsif days_left.zero?
      "#{pluralize(hours_left, 'hour')} #{pluralize(minutes_left, 'minute')}"
    else
      ("#{pluralize(days_left, 'day')} " unless days_left.zero?).to_s +
        ("#{pluralize(hours_left, 'hour')} " unless hours_left.zero?).to_s +
        pluralize(minutes_left, 'minute')
    end
  end

  def show_svg(path)
    File.open("app/assets/images/#{path}", 'rb') do |file|
      raw file.read
    end
  end
end
