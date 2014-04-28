module Events
  class Creator
    def initialize(event_repository) 
      @event_repository = event_repository
    end

    def perform(event_params, on_success:raise, on_failure:raise)
      @event = @event_repository.new(event_params)
      if @event.save
        on_success.call(@event)
      else
        on_failure.call(@event)
      end
    end
  end
end
