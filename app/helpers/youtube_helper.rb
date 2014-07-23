
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
  
  def self.user_videos(user)
      if user_id = user.youtube_id
        tags = followed_project_tags(user)
        return [] if tags.empty?

        request = "http://gdata.youtube.com/feeds/api/users/#{user_id}/uploads?alt=json&max-results=50"
        request += '&fields=entry(author(name),id,published,title,content,link)'

        #tags_filter = escape_query_params(tags)
        #request += '&q=' + tags_filter.join('|')

        response = get_response(request)
        filter_response(response, tags, [youtube_user_name(user)]) if response
      end
    end

    def self.followed_project_tags(user)
      projects = user.following_by_type('Project')
      [].tap do |tags|
        projects.each do |project|
          tags.concat(project_tags(project))
        end
        tags << 'scrum'
        tags.uniq!
      end
    end

    def self.project_videos(project, members)
      members_tags = members_tags(members)
      return [] if members_tags.blank?
      project_tags = project_tags(project)

      request = build_request(escape_query_params(members_tags), escape_query_params(project_tags))
      response = get_response(request)
      filter_response(response, project_tags, members_tags) if response
    end

    def self.build_request(members_filter, project_tags_filter)
      request = 'http://gdata.youtube.com/feeds/api/videos?alt=json&max-results=50'
      request += '&orderby=published'
      request += '&fields=entry(author(name),id,published,title,content,link)'
      #request += '&fields=entry[' + filter.join(' or ') + ']'
      request += '&q=(' + project_tags_filter.join('|') + ')'
      request += '/(' + members_filter.join('|') + ')'
    end

    def self.project_tags(project)
      tags = project.tag_list
      tags << project.title
      tags.map!(&:downcase)
      tags.uniq!
      tags
    end

    def self.members_tags(members)
      return [] if members.blank?
      members_tags = members.map { |user| self.youtube_user_name(user) if youtube_user_name(user) }.compact
      members_tags.map!(&:downcase)
      members_tags.uniq!
      members_tags
    end

    def self.escape_query_params(params)
      params.map do |param|
        if param.index(' ')
          '"' + param.gsub(' ', '+') + '"'
        else
          param
        end
      end
    end

    def self.get_response(request)
      [].tap do |array|
         #TODO YA rescue BadRequest
        response = parse_response(open(URI.escape(request)).read)
        array.concat(response) if response
        array.sort_by! { |video| video[:published] }.reverse! unless array.empty?
      end
    end

    def self.parse_response(response)
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

    def self.filter_response(response, tags, members)
      response.select do |video|
        members.detect { |member| video[:author] =~ /#{member}/i } &&
            tags.detect { |tag| video[:title] =~ /#{tag}/i }
      end
    end

    def self.beautify_youtube_response(hash)
      {
          author: hash['author'].first['name']['$t'],
          id: hash['id']['$t'].split('/').last,
          published: hash['published']['$t'].to_date,
          title: hash['title']['$t'],
          content: hash['content']['$t'],
          url: hash['link'].first['href'],
      }
    end

    #TODO YA add fallback is user_id not found
    def self.user_id(token)
      # API v2
      response = open("https://gdata.youtube.com/feeds/api/users/default?alt=json", 'Authorization' => "Bearer #{token}").read
      json = JSON.load(response)
      json['entry']['yt$username']['$t']
    end

    #TODO YA add this to youtube connection
    def self.youtube_user_name(user)
      unless user.youtube_user_name
        begin
          user.youtube_user_name = user_name(user)
          #user.save  # this is breaking everything sometimes - NEED BETTER FIX
        rescue Exception => e
          Rails.logger.fatal e
        end
      end
      user.youtube_user_name
    end
    private

    def self.video_data(video)
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
