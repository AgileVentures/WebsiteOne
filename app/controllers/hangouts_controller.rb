class HangoutsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :cors_preflight_check

  def update
    hangout = Hangout.find_or_create_by(uid: params[:id])

    if hangout.try!(:update_hangout_data, params)
      SlackService.post_hangout_notification(hangout) if params[:notify] == 'true'

      redirect_to event_path(params[:event_id]) and return if local_request?
      head :ok
    else
      head :internal_server_error
    end
  end

  def index
    @hangouts = params[:live] ? Hangout.live : Hangout.all
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
    request.remote_ip == '127.0.0.1'
  end

  def set_cors_headers
    response.headers['Access-Control-Allow-Origin'] = request.env['HTTP_ORIGIN']
    response.headers['Access-Control-Allow-Methods'] = 'PUT'
  end
end
