
class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_event, only: [:show, :edit, :update, :destroy, :update_only_url]

  def new
    @event = Event.new(new_params)
    @event.set_repeat_ends_string
    @projects = Project.all
  end

  def show
    @event_schedule = @event.next_occurrences
    @recent_hangout = @event.recent_hangouts.first
    render partial: 'hangouts_management' if request.xhr?
  end

  def index
    @project = Project.friendly.find(params[:project_id]) if params[:project_id]
    all_events = @project ? Event.where(project_id: @project) : Event.all
    @projects = Project.all
    @events = all_events.inject([]) do |memo, event|
      memo << event.next_occurrences
    end.flatten.sort_by { |e| e[:time] }
  end

  def edit
    @event.set_repeat_ends_string
    @projects = Project.all
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
      @projects = Project.all
      render :new
    end)
  end

  def update
    begin
      updated = @event.update_attributes(Event.transform_params(params))
    rescue
      attr_error = 'attributes invalid'
    end
    if updated
      flash[:notice] = 'Event Updated'
      redirect_to events_path
    else
      flash[:alert] = ['Failed to update event:', @event.errors.full_messages, attr_error].join(' ')
      redirect_to edit_event_path(@event)
    end
  end

  def destroy
    @event.destroy
    redirect_to events_path
  end

  private

  def set_event
    @event = Event.friendly.find(params[:id])
  end

  def new_params
    params[:project_id] = Project.friendly.find(params[:project]).id.to_s if params[:project]
    params.permit(:name, :category, :project_id).merge(start_datetime: Time.now.utc, duration: 30, repeat_ends: true)
  end
end

