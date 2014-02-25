class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_event, only: [:show, :edit]

  def new
    @event = Event.new
  end

  def show
  end

  def index
    @events = Event.all
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
    if event.save
      flash[:notice] = 'Event Created'
      redirect_to root_path
    else
      render :new
    end
  end

  def update
    e = Event.find(params[:id])
    e.update_attributes(params[:event])
    flash[:notice] = 'Event Updated'
    redirect_to root_path
  end

  def destroy
    event = Event.find(params[:id])
    event.destroy
    redirect_to root_path
  end



  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params[:event].permit(:name, :description,:is_all_day, :from_date, :to_date, :from_time, :to_time)
  end

end
