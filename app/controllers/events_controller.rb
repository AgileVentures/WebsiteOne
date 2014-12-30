
class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_event, only: [:show, :edit, :update, :destroy, :update_only_url]

  def new
    @event = Event.new(start_datetime: Time.now.utc, duration: 30)
    @event.set_repeat_ends_string
  end

  def show
    @event_schedule = @event.next_occurrences
    @recent_hangout = @event.recent_hangouts.first
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
    @event.set_repeat_ends_string
  end

  def create
    EventCreatorService.new(Event).perform(Event.transform_params(params),
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
    begin
      updated = @event.update_attributes(Event.transform_params(params))
    rescue
      attr_error = "attributes invalid"
    end
    if updated
      flash[:notice] = 'Event Updated'
      redirect_to events_path
    else
      flash[:alert] = ['Failed to update event:', @event.errors.full_messages, attr_error].join(' ')
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
end
