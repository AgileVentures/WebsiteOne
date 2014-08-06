class HookupsController < ApplicationController
  def index
    @pending_hookups = Event.pending_hookups
    @active_pp_hangouts = Hangout.pp_hangouts.started.live
  end

  def create
    #Time.use_zone('UTC')
    @event = Event.new
    unless params[:event_date].nil?
      @event.event_date= Date.new(params[:event_date][:year].to_i, params[:event_date][:month].to_i, params[:event_date][:day].to_i)
    end
    @event.name= params['title']
    @event.repeats= 'never'
    start_date = params[:start_date].blank? ? Date.today : params[:start_date].to_datetime
    start_time = params[:start_time].blank? ? Time.now : params[:start_time].to_datetime
    @event.start_datetime = Time.utc(
        start_date.year,
        start_date.month,
        start_date.day,
        start_time.hour,
        start_time.min,
        0)
    @event.duration = params['duration'].to_i
    @event.category= 'PairProgramming'
    @event.description= "hookup"
    @event.time_zone= 'UTC'
    Time.zone= params[:time_zone]
    is_saved = @event.save
    if is_saved
      flash[:notice] = 'Event Created'
      @start_hangout = params['start_hangout']
    else
      flash[:notice] = @event.errors.full_messages.to_sentence
    end
    redirect_to hookups_path
  end
end