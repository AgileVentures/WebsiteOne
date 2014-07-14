require 'open-uri'

module YoutubeHelper
  extend self

  def channel_id(token)
    response = open("https://www.googleapis.com/youtube/v3/channels?part=id&mine=true", 'Authorization' => "Bearer #{token}").read
    json = JSON.load(response)
    json['items'].first['id']
  rescue JSON::ParserError
    raise $!, 'Invalid JSON returned from Youtube', $!.backtrace
  end

  def youtube_user_name(user)
    return unless user.youtube_id
    response = open("https://gdata.youtube.com/feeds/api/users/#{user.youtube_id}?fields=title&alt=json").read
    json = JSON.load(response)
    json['entry']['title']['$t']
  rescue JSON::ParserError
    raise $!, 'Invalid JSON returned from Youtube', $!.backtrace
  end
end
