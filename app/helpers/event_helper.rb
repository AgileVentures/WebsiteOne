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

  def current_occurrence_time(event, data=false)
    time = nested_hash_value(event, :time)
    return nil if time.nil?

    event_date = time.strftime("%A, #{time.day.ordinalize} %b")
    if data
      "#{time.strftime("%F %I:%M %p")} UTC" # parseable by JS; for embedding as 'data' in HTML tags
    else
      "#{event_date} at #{time.strftime("%I:%M%P")} (UTC)" # user-friendly for direct display
    end
  end
  
  def topic(event, event_schedule)
    "#{@event.name} - #{current_occurrence_time(event_schedule.first(1))}"
  end
end
