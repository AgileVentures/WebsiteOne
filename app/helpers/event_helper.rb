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

    time.strftime("%F at %I:%M%p")
  end
end
