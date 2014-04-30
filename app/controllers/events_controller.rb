class EventsController < ApplicationController
  #require 'delorean'

  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_event, only: [:show, :edit, :update, :destroy, :update_only_url]

  def new
    @event = Event.new
  end

  def show
    @event_schedule = @event.current_occurences
    #puts @event_schedule
  end

  def index
    @events = []
    Event.all.each do |event|
      @events << event.current_occurences
    end
    @events = @events.flatten.sort_by { |e| e[:time] }
  end

  def edit
  end

  def create
    EventCreatorService.new(Event).perform(normalize_event_dates(event_params),
                                       success: ->(event) do
      @event = event
      flash[:notice] = 'Event Created'
      redirect_to event_path(@event)
    end,
    failure: ->(event) do
      @event = event
      flash[:notice] = @event.errors.full_messages.to_sentence
      render :new
    end)
  end

  def update
    if @event.update_attributes(event_params)
      flash[:notice] = 'Event Updated'
      redirect_to events_path
    else
      flash[:alert] = ['Failed to update event:', @event.errors.full_messages].join(' ')
      redirect_to edit_event_path(@event)
    end
  end

  def update_only_url
    if @event.update_attributes(params[:event].permit(:url))
      flash[:notice] = 'Event URL has been updated'
    else
      flash[:alert] = 'You have to provide a valid hangout url'
    end
    redirect_to event_path(@event)
  end

  def destroy
    @event.destroy
    redirect_to events_path
  end

  private

  def set_event
    @event = Event.friendly.find(params[:id])
  end


  def event_params
    params.require(:event).permit!
  end

  def normalize_event_dates(event_params)
    event_params[:event_date] = EventDate.for(event_params[:event_date])
    event_params[:start_time] = StartTime.for(event_params[:start_time])
    event_params[:end_time] = EndTime.for(event_params[:end_time])
    event_params
  end

end
