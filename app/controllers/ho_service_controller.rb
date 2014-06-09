class HoServiceController < ApplicationController
  def update
    puts params.inspect
    video = Video.find_or_create_by(video_id: params['startData'] )
    video.update(status: 'In progress',
                 # host: params['Host'],
                 hangout_url: params['hangoutUrl'],
                 youtube_id: params['YouTubeLiveId'],
                 # currently_in: params['Currently in'],
                 # participants: params['Participants']
                ) if video
    render text: 'Success'
  end
end

# Parameters: {"hangoutUrl"=>"https://talkgadget.google.com/hangouts/_/g5r2gwryr2nw6z7szfiz7fr3cia",
#              "startData"=>"3",
#              "YouTubeLiveId"=>"NHtFbG1kvqE",
#              "participants"=>{"0"=>{"id"=>"hangoutEDEDFCE8_ephemeral.id.google.com^f65363a17f62f0",
#                                     "hasMicrophone"=>"true",
#                                     "hasCamera"=>"true",
#                                     "hasAppEnabled"=>"true",
#                                     "isBroadcaster"=>"true",
#                                     "isInBroadcast"=>"true",
#                                     "displayIndex"=>"0",
#                                     "person"=>{"id"=>"116165074659834940273",
#                                                "displayName"=>"Yaro Apletov",
#                                                "image"=>{"url"=>"https://lh3.googleusercontent.com/-aXiUNPe6O5Q/AAAAAAAAAAI/AAAAAAAAAAA/4OvZ0A7P7H4/s96-c/photo.jpg"},
#                                                "pa"=>"false"},
#                                                "locale"=>"ru",
#                                                "pa"=>"false"}},
#                                                "id"=>"3"}
