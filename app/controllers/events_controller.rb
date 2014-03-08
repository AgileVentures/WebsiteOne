class EventsController < ApplicationController
  #require 'delorean'

  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def new
    @event = Event.new
  end

  def show
    @event_schedule = []
    @event_schedule << @event.current_occurences if @event.present?
    @event_schedule.flatten!
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
    if params[:event][:event_date].empty?
      params[:event][:event_date] = Date.today
    end
    if params[:event][:start_time].empty?
      params[:event][:start_time] = Time.now
    end
    if params[:event][:end_time].empty?
      params[:event][:end_time] = Time.now + 30.minutes
    end
    @event = Event.new(event_params)
    if @event.save
      flash[:notice] = 'Event Created'
      redirect_to events_path
    else
      flash[:notice] = @event.errors.full_messages.to_sentence
      render :new
    end
  end

  def update
    @event.update_attributes(event_params)
    flash[:notice] = 'Event Updated'
    redirect_to events_path
  end

  def update_only_url
    @event.update_attributes(params[:event].permit(:url))
    flash[:notice] = 'Event URL has been updated'
    redirect_to event_path(@event)
  end

  def destroy
    @event.destroy
    redirect_to events_path
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end


  def event_params
    params.require(:event).permit!
  end


end