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

#TODO YA move to a separate helper module and upgrade to v3
module Youtube
  class << self

    def user_videos(user)
      if user_id = user.youtube_id
        tags = followed_project_tags(user)

        request = "http://gdata.youtube.com/feeds/api/users/#{user_id}/uploads?alt=json&max-results=50&orderby=published"
        request += '&fields=entry(author(name),id,published,title,content,link)'
        request += '&q="' + tags.join('"|"') + '"'
        request += '&start-index='
        p URI.escape(request)
        get_response(request)
      end
    end

    def followed_project_tags(user)
      projects = user.following_by_type('Project')
      [].tap do |tags|
        projects.each do |project|
          tags << project.tag_list
          tags << project.title
          tags << 'scrum'
        end
        tags.flatten!
        tags.uniq!
        tags.map! { |tag| tag.gsub(' ', '+') }
      end
    end

    def project_videos(project, members)
      return [] if members.empty?

      filter = members.map { |user| "author/name='" + youtube_user_name(user) + "'" if youtube_user_name(user) }.compact
      filter.map! { |member| member.gsub(' ', '+') }
      return [] if filter.empty?

      tags = project.tag_list
      tags << project.title
      tags.uniq!
      tags.map! { |tag| tag.gsub(' ', '+') }

      request = 'http://gdata.youtube.com/feeds/api/videos?alt=json&max-results=50&orderby=published'
      request += '&q="' + tags.join('"|"') + '"'

      request += '&fields=entry[' + filter.join('+or+') + ']'
      request += '(author(name),id,published,title,content,link)'
      request += '&start-index='
      p URI.escape(request)
      get_response(request)
    end

    def get_response(request, increment = 50)
      index = 1
      [].tap do |array|
        #TODO YA commented out temporary to limit the number of requests
        #while response = parse_response(open(URI.escape(request + index.to_s)).read)
        #  index += increment
        #  array.concat(response)
        #end
        #TODO YA rescue BadRequest
        response = parse_response(open(URI.escape(request + '1')).read)
        array.concat(response) if response
        #array.sort_by! { |video| video[:published] }.reverse! unless array.empty?
      end
    end

    def parse_response(response)
      begin
        json = JSON.parse(response)

        videos = json['feed']['entry']
        return if videos.nil?

        videos.map { |hash| beautify_youtube_response(hash) }
      rescue JSON::JSONError
        Rails.logger.warn('Attempted to decode invalid JSON')
        nil
      end
    end

    def beautify_youtube_response(hash)
      {
          author: hash['author'].first['name']['$t'],
          id: hash['id']['$t'].split('/').last,
          published: hash['published']['$t'].to_date,
          title: hash['title']['$t'],
          content: hash['content']['$t'],
          url: hash['link'].first['href'],
      }
    end

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
        user.youtube_user_name = user_name(user)
        user.save
      end

      user.youtube_user_name
    end

  end
end

