module YoutubeVideos
  extend self

  def for(object)
    self.send("#{object.class.to_s.downcase}_videos", object)
  end

  private

  def user_videos(object)
    return unless object.youtube_id

    response = get_response(build_request_for_user_videos(object))
    filter_response(response, object.followed_project_tags, [object.youtube_user_name]) if response
  end

  def project_videos(object)
    request = build_request_for_project_videos(object)
    response = get_response(request)
    filter_response(response, object.youtube_tags, object.members_tags) if response
  end

  def build_request_for_user_videos(user)
    "http://gdata.youtube.com/feeds/api/users/#{user.youtube_id}/uploads?alt=json&max-results=50" +
     '&fields=entry(author(name),id,published,title,content,link)'
  end

  def build_request_for_project_videos(project)
    'http://gdata.youtube.com/feeds/api/videos?alt=json&max-results=50' +
    '&orderby=published&fields=entry(author(name),id,published,title,content,link)' +
    '&q=' + escape_query_params(project.youtube_tags) +
    '/' + escape_query_params(project.members_tags)
  end

  def escape_query_params(params)
    '(' + params.map do |param|
      if param.index(' ')
        '"' + param.gsub(' ', '+') + '"'
      else
        param
      end
    end.join('|') + ')'
  end

  def get_response(request)
    [].tap do |array|
      #TODO YA rescue BadRequest
      response = parse_response(open(URI.escape(request)).read)
      array.concat(response) if response
      array.sort_by! { |video| video[:published] }.reverse! unless array.empty?
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

  def filter_response(response, tags, members)
    response.select do |video|
      members.detect { |member| video[:author] =~ /#{member}/i } &&
        tags.detect { |tag| video[:title] =~ /#{tag}/i }
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
end
