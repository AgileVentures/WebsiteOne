class HookupsController < ApplicationController
  def index
    @pending_hookups = Event.pending_hookups
    @active_pp_hangouts = Hangout.pp_hangouts.started.live
  end

  def create
    @event = Event.new(name: params['title'],
                       repeats: 'never',
                       duration: params['duration'].to_i,
                       category: 'PairProgramming',
                       description: "hookup",
                       time_zone: 'UTC'

    )
    @event.start_datetime = @event.start_datetime_from_params(params)
    is_saved = @event.save
    if is_saved
      flash[:notice] = 'Event Created'
    else
      flash[:notice] = @event.errors.full_messages.to_sentence
    end
    redirect_to hookups_path
  end
end