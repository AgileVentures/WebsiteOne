class EventCreatorService
  def initialize(event_repository)
    @event_repository = event_repository
  end

  def perform(event_params, success:raise, failure:raise)
    @event = @event_repository.new(event_params)
    if @event.save
      success.call(@event)
    else
      failure.call(@event)
    end
  end
end
