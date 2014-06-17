class EventCreatorService
  def initialize(event_repository)
    @event_repository = event_repository
  end

  def perform(event_params, success:raise, failure:raise)
    @event = @event_repository.new(normalize_event_dates(event_params))
    if @event.save
      success.call(@event)
    else
      failure.call(@event)
    end
  end

  private 

  def normalize_event_dates(event_params)
    event_params[:event_date] = EventDate.for(event_params[:event_date])
    event_params[:start_time] = StartTime.for(event_params[:start_time])
    event_params[:end_time] = EndTime.for(event_params[:end_time])
    event_params
  end
end
