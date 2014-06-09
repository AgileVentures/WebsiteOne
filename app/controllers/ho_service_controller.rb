class HoServiceController < ApplicationController
  def update
    video = Video.find_or_create_by(video_id: params[:id])
    if video && video.update(status: 'In progress',
                             # host: params['Host'],
                             hangout_url: params['hangoutUrl'],
                             youtube_id: params['YouTubeLiveId'],
                             # currently_in: params['Currently in'],
                             # participants: params['Participants']
                            )
      response.headers['Access-Control-Allow-Origin'] = '*'
      response.headers['Access-Control-Request-Method'] = 'GET'

      render text: 'Success'
    else
      render text: 'Failure'
    end
  end
end

