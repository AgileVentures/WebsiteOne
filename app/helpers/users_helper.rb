require 'open-uri'

module UsersHelper

  def user_display_name user
    first = user.try(:first_name)
    last = user.try(:last_name)
    str = first.to_s + last.to_s
    if first && last
      [first, last].join(' ')
    elsif !first && !last
      # User has not filled in their profile
      user.email.split('@').first
    else
      str
    end
  end


  def link_to_youtube_button(origin_url)
    link_to raw('<i class="fa fa-large fa-youtube"></i> Sync with YouTube'),
            "/auth/gplus/?youtube=true&origin=#{origin_url}", class: "btn btn-danger btn-lg", type: "button"
  end

  def unlink_from_youtube_button(origin_url)
    link_to raw('<i class="fa fa-large fa-youtube"></i> Disconnect YouTube'),
            "/auth/destroy/youtube?origin=#{origin_url}", class: "btn btn-danger btn-lg", type: "button"
  end

  def video_link(video)
    link_to video[:title], video[:url], id: video[:id], class: 'yt_link', data: { content: video[:content] }
  end

  def video_embed_link(video)
    "http://www.youtube.com/embed/#{video[:id]}?enablejsapi=1"
  end

end

#TODO YA move to a separate helper module
module Youtube
  class << self

    def user_videos(user, tags = [])
      if user_id = user.youtube_id
        request = "http://gdata.youtube.com/feeds/api/users/#{user_id}/uploads?alt=json"
        request += '&q=' + tags.join('%7C') unless tags.empty? # %7C is an escaped '|' pipe sign

        parse_response(open(request).read, user)
      end
    end

    def parse_response(response, user = '')
      begin
        json = JSON.parse(response)
        links = json['feed']['link']
        next_link = links.detect{|link| link['rel']=='next'}
        total = json['feed']['openSearch$totalResults']['$t']

        videos = json['feed']['entry']
        return if videos.nil?
        videos.map do |hash|
          {
              id: hash['id']['$t'].split('/').last,
              published: hash['published']['$t'].to_date,
              title: hash['title']['$t'],
              content: hash['content']['$t'],
              url: hash['link'].first['href'],
              thumbs: hash['media$group']['media$thumbnail'],
              player_url: hash['media$group']['media$player'].first['url'],
              user: user
          }
        end
      rescue JSON::JSONError
        Rails.logger.warn('Attempted to decode invalid JSON')
        nil
      end
    end

    def channel_id(token)
      # API v3
      json = JSON.load(open("https://www.googleapis.com/youtube/v3/channels?access_token=#{token}&part=id&mine=true").read)
      json['items'].first['id']
    end

    def user_id(token)
      # API v2
      json = JSON.load(open("https://gdata.youtube.com/feeds/api/users/default?access_token=#{token}&alt=json").read)
      json['entry']['yt$username']['$t']
    end

    def user_name(token)
      # API v2
      json = JSON.load(open("https://gdata.youtube.com/feeds/api/users/default?access_token=#{token}&alt=json").read)
      json['entry']['title']['$t']
    end

  end
end

