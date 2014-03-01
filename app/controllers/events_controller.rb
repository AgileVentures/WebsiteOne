class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def new
    @event = Event.new
  end

  def show
  end

  def index
    #@events = Event.all.order(from_date: :desc)
    @events = []
    Event.all.each do |event|
      event.schedule.occurrences_between(Date.today, event.repeat_ends_on).each do |time|
      #event.schedule.occurrences(120.days.since).each do |time|
        @events << {
            event: event,
            time: time
        }
      end
    end
    @events = @events.sort_by { |e| e[:time] }
  end

  def edit
  end

  def create
    if params[:event][:from_date].empty?
      params[:event][:from_date] = Date.today
    end
    if params[:event][:to_date].empty?
      params[:event][:to_date] = Date.today
    end
    if params[:event][:is_all_day] == '0'
      if params[:event][:from_time].empty?
        params[:event][:from_time] = Time.now.beginning_of_day
      end
      if params[:event][:to_time].empty?
        params[:event][:to_time] = Time.now.end_of_day
      end
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

  def destroy
    @event.destroy
    redirect_to events_path
  end


  private

  def set_event
    @event = Event.find(params[:id])
  end

  def end_of_day

  end

  def beginning_of_day

  end

  def event_params
    params.require(:event).permit!
    #params[:event].permit(:name,
    #                      :category,
    #                      :description,
    #                      :is_all_day,
    #                      :from_date,
    #                      :to_date,
    #                      :from_time,
    #                      :to_time,
    #                      :time_zone,
    #                      :repeats,
    #                      :repeats_every_n_days,
    #                      :repeats_every_n_weeks,
    #                      :repeats_weekly_each_days_of_the_week,
    #                      :repeats_monthly_each_days_of_the_month,
    #                      :repeats_monthly_on_ordinals,
    #                      :repeats_monthly_on_days_of_the_week,
    #                      :repeats_yearly_each_months_of_the_year,
    #                      :repeats_yearly_on_ordinals,
    #                      :repeats_yearly_on_days_of_the_week,
    #                      :repeat_ends,
    #                      :repeat_ends_on
    #)
  end


end