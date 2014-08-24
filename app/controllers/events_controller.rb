class EventsController < ApplicationController
  #require 'delorean'

  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_event, only: [:show, :edit, :update, :destroy, :update_only_url]

  def new
    @event = Event.new(start_datetime: Time.now.utc, duration: 30)
  end

  def show
    @event_schedule = @event.next_occurrences
    @hangout = @event.last_hangout
    render partial: 'hangouts_management' if request.xhr?
  end

  def index
    @events = []
    Event.all.each do |event|
      @events << event.next_occurrences
    end
    @events = @events.flatten.sort_by { |e| e[:time] }
  end

  def edit
  end

  def create
    EventCreatorService.new(Event).perform(event_params,
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
    temp_params = params.require(:event).permit!
    temp_params[:start_datetime] = "#{params['start_date']} #{params['start_time']} UTC"
    temp_params
  end

end
