# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :authenticate_user!, except: %i(index show)
  before_action :set_event, only: %i(show edit update destroy update_only_url)
  before_action :set_projects, only: %i(new edit update create)

  def index
    @projects = Project.active
    @events = Event.upcoming_events(specified_project)
    respond_to do |format|
      format.html { @events }
      format.json do
        @scrums = EventInstance.this_month_until_now
      end
    end
  end

  def show
    @event_schedule = @event.next_occurrences
    @recent_hangout = @event.recent_hangouts.first
    @event_instances = EventInstance.where(event_id: @event.id).where.not(yt_video_id: nil)
                                    .order(created_at: :desc).limit(5)
    @project = @event.project
    render partial: 'hangouts_management' if request.xhr?
  end

  def new
    @event = Event.new(new_params)
    @event.set_repeat_ends_string
  end

  def edit
    @event.set_repeat_ends_string
  end

  def create
    @event = Event.new(normalize_event_dates(transform_params))
    if @event.save
      flash[:notice] = 'Event Created'
      redirect_to event_path(@event)
    else
      flash.now[:notice] = @event.errors.full_messages.to_sentence
      render :new
    end
  end

  def update
    begin
      updated = @event.update(transform_params)
    rescue StandardError
      attr_error = 'attributes invalid'
    end
    if updated
      flash[:notice] = 'Event Updated'
      redirect_to event_path(@event)
    else
      flash.now[:alert] = ['Failed to update event:', @event.errors.full_messages, attr_error].join(' ')
      @projects = Project.all
      render 'edit'
    end
  end

  def destroy
    @event.destroy
    redirect_to events_path
  end

  private

  def transform_params
    event_params = whitelist_event_params
    create_start_date_time(event_params)
    # check_days_of_week(event_params)
    event_params[:repeat_ends] = (event_params[:repeat_ends_string] == 'on')
    event_params[:repeats_every_n_weeks] = 2 if event_params['repeats'] == 'biweekly'
    event_params
  end

  def normalize_event_dates(event_params)
    event_params[:start_datetime] = Time.now if event_params[:start_datetime].blank?
    event_params[:duration] = 30.minutes if event_params[:duration].blank?
    event_params[:repeat_ends] = event_params[:repeat_ends_string] == 'on'
    event_params
  end

  def whitelist_event_params
    permitted = %i(
      name category for project_id description duration repeats
      repeats_every_n_weeks repeat_ends_string time_zone creator_id
      start_datetime repeat_ends repeat_ends_on modifier_id creator_attendance
    )

    params.merge(event: params[:event].merge(action_initiator))
          .require(:event)
          .permit(permitted, repeats_weekly_each_days_of_the_week: [])
  end

  def action_initiator
    @event&.creator_id ? { modifier_id: current_user.id } : { creator_id: current_user.id }
  end

  def create_start_date_time(event_params)
    # return unless date_and_time_present?

    tz = TZInfo::Timezone.get(params['start_time_tz'])
    event_params[:start_datetime] = tz.local_to_utc(DateTime.parse(params[:start_datetime]))
    # local_to_utc(params[:start_datetime]) # DateTime.parse("#{params['start_date']} #{params['start_time']}"))
  end

  def check_days_of_week(event_params)
    # local timezone vs utc timezone
    # return unless date_and_time_present?

    offset = (DateTime.parse(params[:start_date]).wday - event_params[:start_datetime].wday) % 7
    return event_params['repeats_weekly_each_days_of_the_week'] if offset.zero?

    event_params['repeats_weekly_each_days_of_the_week'] = []
    params['event']['repeats_weekly_each_days_of_the_week'].each do |day|
      if day != ''
        event_params['repeats_weekly_each_days_of_the_week'] << Date::DAYNAMES[(Date.parse(day).wday - offset) % 7].downcase
      end
    end
  end

  def date_and_time_present?
    params['start_datetime'].present?
    # and params['start_time'].present?
  end

  def specified_project
    @project = Project.friendly.find(params[:project_id]) if params[:project_id].present?
  end

  def set_event
    @event = Event.friendly.find(params[:id]) || Event.find_by(slug: params[:id])
  end

  def set_projects
    @projects = Project.active.map { |project| [project.title, project.id] }
  end

  def new_params
    params[:project_id] = Project.friendly.find(params[:project]).id.to_s if params[:project]
    params[:project_id] = Project.find_by(title: 'CS169').try(:id) unless params[:project_id]
    params.permit(:name, :category, :for, :project_id).merge(start_datetime: Time.now.utc, duration: 30,
                                                             repeat_ends: true)
  end
end
