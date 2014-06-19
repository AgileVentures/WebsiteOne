class YoutubeVideosService
  def initialize(object)
    @object = object
  end

  def videos
    self.send("#{@object.class.to_s.downcase}_videos")
  end

  private

  def user_videos
    if user_id = @object.youtube_id
      tags = followed_project_tags
      return [] if tags.empty?

      request = "http://gdata.youtube.com/feeds/api/users/#{user_id}/uploads?alt=json&max-results=50"
      request += '&fields=entry(author(name),id,published,title,content,link)'

      response = get_response(request)
      filter_response(response, tags, [YoutubeHelper.youtube_user_name(@object)]) if response
    end
  end

  def project_videos
    return [] if members_tags.blank?

    request = build_request(escape_query_params(members_tags), escape_query_params(project_tags))
    response = get_response(request)
    filter_response(response, project_tags, members_tags) if response
  end

  def followed_project_tags
    projects = @object.projects_joined
    [].tap do |tags|
      projects.each do |project|
        tags.concat(self.class.new(project).send(:project_tags))
      end
      tags << 'scrum'
      tags.uniq!
    end
  end

  def build_request(members_filter, project_tags_filter)
    request = 'http://gdata.youtube.com/feeds/api/videos?alt=json&max-results=50'
    request += '&orderby=published'
    request += '&fields=entry(author(name),id,published,title,content,link)'
    #request += '&fields=entry[' + filter.join(' or ') + ']'
    request += '&q=(' + project_tags_filter.join('|') + ')'
    request += '/(' + members_filter.join('|') + ')'
  end

  def project_tags
    tags = @object.tag_list
    tags << @object.title
    tags.map!(&:downcase)
    tags.uniq!
    tags
  end

  def members_tags
    return [] if @object.members.blank?
    members_tags = @object.members.map { |user| YoutubeHelper.youtube_user_name(user) if YoutubeHelper.youtube_user_name(user) }.compact
    members_tags.map!(&:downcase)
    members_tags.uniq!
    members_tags
  end

  def escape_query_params(params)
    params.map do |param|
      if param.index(' ')
        '"' + param.gsub(' ', '+') + '"'
      else
        param
      end
    end
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
