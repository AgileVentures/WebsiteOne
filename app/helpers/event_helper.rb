module EventHelper
  def cover_for(event)
    case event.category
      when 'PairProgramming'
        image_path('event-pairwithme-cover.png')

      when 'Scrum'
        image_path('event-scrum-cover.png')

      else
        ''
    end
  end

  def current_occurrence_time(event)
    time = nested_hash_value(event, :time)
    return nil if time.nil?

    event_date = time.strftime("%A, #{time.day.ordinalize} %b")
    "#{event_date} at #{time.strftime("%I:%M%P (%Z)")}"
  end

  def current_occurrence_local_time(event)
    time = nested_hash_value(event, :time)
    time.nil? ? nil : local_time(time, '%b %e at %I:%M%P (%Z)')
  end
  
  def topic(event, event_schedule)
    "#{@event.name} - #{current_occurrence_time(event_schedule.first(1))}"
  end

  def format_timepicker(datetime)
    !datetime.blank? ? datetime.strftime('%I:%M %P') : ''
  end

  def format_datepicker(datetime)
    !datetime.blank? ? datetime.strftime('%Y-%m-%d') : ''
  end

  def format_datetimepicker(datetime)
    !datetime.blank? ? datetime.strftime('%Y-%m-%d %I:%M %P') : ''
  end

  def start_time_with_timezone(event)
    DateTime.parse(event.start_time.strftime('%k:%M ')).in_time_zone(event.time_zone)
  end

  def format_time_range(event)
    start_time_format = event.start_time.strftime('%H:%M')
    end_time_format = event.instance_end_time.strftime('%H:%M')
    "#{start_time_format}-#{end_time_format} UTC"
  end

  def format_time(datetime)
    "#{datetime.strftime('%H:%M')} UTC"
  end

  def format_date(datetime)
    datetime.strftime('%F')
  end
end
