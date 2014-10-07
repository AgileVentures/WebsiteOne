class EventInstancesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :cors_preflight_check, except: [:index]

  def update
    is_created = is_updated = false
    event_instance = EventInstance.find_by(uid: params[:id])
    if !event_instance.present?
      event_instance = EventInstance.create(event_instance_params_new_from_gh)
      is_created = event_instance.present?
    else
      is_updated = event_instance.update_attributes(event_instance_params_update_from_gh)
    end
    if is_created || is_updated
      SlackService.post_hangout_notification(event_instance) if params[:notify] == 'true' && is_created
      redirect_to(event_path params[:event_id]) && return if local_request? && params[:event_id].present?
      head :ok
    else
      head :internal_server_error
    end
  end

  def index
    @event_instances = (params[:live] == 'true') ? EventInstance.live : EventInstance.latest
    render partial: 'hangouts' if request.xhr?
  end

  private

  def cors_preflight_check
    head :bad_request and return unless (allowed? || local_request?)

    set_cors_headers
    head :ok and return if request.method == 'OPTIONS'
  end

  def allowed?
    allowed_sites = %w(a-hangout-opensocial.googleusercontent.com)
    origin = request.env['HTTP_ORIGIN']
    allowed_sites.any? { |url| origin =~ /#{url}/ }
  end

  def local_request?
    request.remote_ip == '127.0.0.1'
  end

  def set_cors_headers
    response.headers['Access-Control-Allow-Origin'] = request.env['HTTP_ORIGIN']
    response.headers['Access-Control-Allow-Methods'] = 'PUT'
  end

  # this is called from the callback from Google Hangouts when creating a new event_instance
  def event_instance_params_new_from_gh
    params.require(:title)
    ActionController::Parameters.new(
        title: params[:title],
        project_id: params[:project_id],
        event_id: params[:event_id],
        category: params[:category],
        user_id: params[:hostId],
        participants: params[:participants],
        hangout_url: params[:hangout_url],
        yt_video_id: params[:yt_video_id],
        uid: params[:id],
        start: Time.now,
        heartbeat: Time.now,
        start_planned: Time.now
    ).permit!
  end

  # this is called from the callback from Google Hangouts when updating an existing event_instance
  def event_instance_params_update_from_gh
    params.require(:title)
    ActionController::Parameters.new(
        participants: params[:participants],
        hangout_url: params[:hangout_url],
        yt_video_id: params[:yt_video_id],
        uid: params[:id],
        heartbeat: Time.now
    ).permit!
  end
end
