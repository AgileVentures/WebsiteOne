class HangoutsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :cors_preflight_check

  def update
    hangout = Hangout.find_or_create_by(event_id: params[:id])

    if hangout.try!(:update_hangout_data, params)
      render text: 'Success'
    else
      render text: 'Failure'
    end
  end

  private

  def cors_preflight_check
    head :bad_request and return unless allowed?

    set_cors_headers
    head :ok and return if request.method == 'OPTIONS'
  end

  def allowed?
    allowed_sites = %w(a-hangout-opensocial.googleusercontent.com)
    origin = request.env['HTTP_ORIGIN']
    allowed_sites.any?{ |url| origin =~ /#{url}/ }
  end

  def set_cors_headers
    response.headers['Access-Control-Allow-Origin'] = request.env['HTTP_ORIGIN'].gsub(/^.*\/\//,'')
    response.headers['Access-Control-Allow-Methods'] = 'PUT'
  end
end
