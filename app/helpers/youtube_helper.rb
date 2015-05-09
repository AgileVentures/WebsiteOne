require 'open-uri'

module YoutubeHelper
  extend self

  def channel_id(token)
    response = open("https://www.googleapis.com/youtube/v3/channels?part=id&mine=true", 'Authorization' => "Bearer #{token}").read
    json = JSON.load(response)
    json['items'].first['id']
    rescue JSON::ParserError => err
    raise err, 'Invalid JSON returned from Youtube', err.backtrace
  end

  def youtube_user_name(user)
    return unless user.youtube_id
    response = open("https://gdata.youtube.com/feeds/api/users/#{user.youtube_id}?fields=title&alt=json").read
    json = JSON.load(response)
    json['entry']['title']['$t']
    rescue JSON::ParserError => err
    raise err, 'Invalid JSON returned from Youtube', err.backtrace
  end

  def video_data(video)
    {
      author: video.author.name,
      id: video.video_id.scan(/tag:youtube.com,\d+:video:(.+)/).last.first,
      published: video.published_at.to_date,
      title: video.title,
      content: video.title,
      url: video.media_content[0].url
    }
  end
end
