require 'open-uri'

module YoutubeHelper
    def channel_id(token)
      # API v3
      response = open("https://www.googleapis.com/youtube/v3/channels?part=id&mine=true", 'Authorization' => "Bearer #{token}").read
      json = JSON.load(response)
      json['items'].first['id']
    end

    #TODO YA add fallback is user_id not found
    def user_id(token)
      # API v2
      response = open("https://gdata.youtube.com/feeds/api/users/default?alt=json", 'Authorization' => "Bearer #{token}").read
      json = JSON.load(response)
      json['entry']['yt$username']['$t']
    end

    def user_name(user)
      # API v2
      return unless user.youtube_id
      response = open("https://gdata.youtube.com/feeds/api/users/#{user.youtube_id}?fields=title&alt=json").read
      json = JSON.load(response)
      json['entry']['title']['$t']
    end

    #TODO YA add this to youtube connection
    def youtube_user_name(user)
      unless user.youtube_user_name
        begin
          user.youtube_user_name = user_name(user)
          #user.save  # this is breaking everything sometimes - NEED BETTER FIX
        rescue Exception => e
          logger.fatal e
        end
      end
      user.youtube_user_name
    end
end
