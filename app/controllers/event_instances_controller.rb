class EventInstancesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :cors_preflight_check, except: [:index]

  def update
    event_instance = EventInstance.find_or_create_by(uid: params[:id])

    if event_instance.try!(:update, hangout_params)
      SlackService.post_hangout_notification(event_instance) if params[:notify] == 'true'
      TwitterService.tweet_hangout_notification(event_instance) if event_instance.started? && event_instance.hangout_url_changed?
      TwitterService.tweet_yt_link(event_instance) if event_instance.yt_video_id_changed?

      redirect_to(event_path params[:event_id]) && return if local_request? && params[:event_id].present?
      head :ok
    else
      head :internal_server_error
    end
  end

  def index
    relation = (params[:live] == 'true') ? EventInstance.live : EventInstance.latest
    relation = relation.includes(:project, :event, :user)
    @event_instances = relation.paginate(:page => params[:page])
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
    allowed_sites.any?{ |url| origin =~ /#{url}/ }
  end

  def local_request?
    request.env['HTTP_ORIGIN'] =~ /#{request.env['HTTP_HOST']}/
  end

  def set_cors_headers
    response.headers['Access-Control-Allow-Origin'] = request.env['HTTP_ORIGIN']
    response.headers['Access-Control-Allow-Methods'] = 'PUT'
  end

  def hangout_params
    params.require(:host_id)
    params.require(:title)

    ActionController::Parameters.new(
      title: params[:title],
      project_id: params[:project_id],
      event_id: params[:event_id],
      category: params[:category],
      user_id: params[:host_id],
      participants: params[:participants],
      hangout_url: params[:hangout_url],
      yt_video_id: params[:yt_video_id],
      hoa_status: params[:hoa_status]
    ).permit!
  end
end
