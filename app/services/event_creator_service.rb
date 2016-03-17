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
    event_params[:start_datetime] =  Time.now if event_params[:start_datetime].blank?
    event_params[:duration] = 30.minutes if event_params[:duration].blank?
    event_params[:repeat_ends] = (event_params[:repeat_ends_string] == 'on') ? true : false
    event_params
  end
end
