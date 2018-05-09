module EventHelper

  def current_occurrence_time(event)
    time = nested_hash_value(event, :time)
    return nil if time.nil?

    event_date = time.strftime("%A, #{time.day.ordinalize} %b")
    "#{event_date} at #{time.strftime("%I:%M%P (%Z)")}"
  end

  def topic(event, event_schedule)
    "#{event.name} - #{current_occurrence_time(event_schedule.first(1))}"
  end

  def format_timepicker(datetime)
    !datetime.blank? ? datetime.strftime('%I:%M %P') : ''
  end

  def format_datepicker(datetime)
    !datetime.blank? ? datetime.strftime('%Y-%m-%d') : ''
  end

  def format_time_range(event)
    start_time_format = event.start_time.strftime('%H:%M')
    end_time_format = event.instance_end_time.strftime('%H:%M')
    "#{start_time_format}-#{end_time_format} #{event.start_time.strftime('(%Z)')}"
  end

  def format_time(datetime)
    "#{datetime.strftime('%H:%M')} UTC"
  end

  def format_date(datetime)
    datetime.strftime('%F')
  end

  def show_local_time_range(time, duration)
    start_time = local_time(time, '%H:%M')
    end_time = local_time(time+duration*60, '%H:%M (%Z)')
    "#{start_time}-#{end_time}"
  end

  def google_calendar_link(event)
    "https://calendar.google.com/calendar/render?action=TEMPLATE&dates=#{event.next_event_occurrence_with_time[:time].strftime('%Y%m%dT%H%M%SZ')}%2f#{(event.next_event_occurrence_with_time[:time] + @event.duration*60).strftime('%Y%m%dT%H%M%SZ')}&sprop=website:#{auto_link(event.description)}&text=#{event.name}&location=online&sprop=name:AgileVentures&details=#{event.description}"
  end

  def set_column_width
    @event.modifier_id ? '<div class="col-xs-12 col-sm-2"></div>'.html_safe : '<div class="col-xs-12 col-sm-4"></div>'.html_safe
  end
end
