module EventHelper
  def cover_for(event)
    @event = Event.find(event)
    if @event.category == 'PairProgramming'
      image_path('event-pairwithme-cover.png')
    else
      image_path('event-scrum-cover.png')
    end
  end
end
