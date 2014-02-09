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

  def date_format(date)
    date.strftime("#{date.day.ordinalize} %b %Y")
  end

end

#TODO YA move to a separate helper module
module Youtube
  class << self

    def user_videos(user, token)
      #user_id = user.youtube_id || channel_id(token)
      user_id = 'UCgTOz02neY70sqnk05zNkGA'
      parse_response(open("http://gdata.youtube.com/feeds/api/users/#{user_id}/uploads?alt=json").read)
    end

    def parse_response(response)
      json = JSON.parse(response)
      videos = json['feed']['entry']
      videos.map do |hash|
        {
            id: hash['id']['$t'].split('/').last,
            published: hash['published']['$t'].to_date,
            title: hash['title']['$t'],
            content: hash['content']['$t'],
            url: hash['link'].first['href'],
            thumbs: hash['media$group']['media$thumbnail'],
            player_url: hash['media$group']['media$player'].first['url']
        }
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

  end
end

