class HoServiceController < ApplicationController
  def update
    puts params.inspect
    video = Video.find_or_create_by(video_id: params['startData'] )
    video.update(hangout_url: params['hangoutUrl']) if video
    render text: 'Success'
  end
end
