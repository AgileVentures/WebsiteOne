class HangoutsController < ApplicationController
  def update
    hangout = Hangout.find_or_create_by(event_id: params[:id])

    if hangout && hangout.update_hangout_data(params)
      response.headers['Access-Control-Allow-Origin'] = '*'
      response.headers['Access-Control-Request-Method'] = 'GET'
      render text: 'Success'
    else
      render text: 'Failure'
    end
  end
end
