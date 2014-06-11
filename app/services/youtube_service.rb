class YoutubeService
  def initialize object
    @object = object
  end

  def videos
    self.send("#{@object.class.to_s.downcase}_videos")
  end

  private

  def project_videos
    request = build_request_for_project_videos(members_tags, project_tags)
    response = get_response(request)
    filter_response(response, project_tags, members_tags)
  end

  def user_videos
    return unless @object.youtube_id?

    response = get_response(build_request_for_user_videos)
    filter_response(response, followed_project_tags, [YoutubeHelper.youtube_user_name(@object)])
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

  def followed_project_tags
    [].tap do |tags|
      @object.projects_joined.each do |project|
        tags.concat(self.class.new(project).send(:project_tags))
      end
      tags << 'scrum'
      tags.uniq!
    end
  end

  def build_request_for_project_videos(project_tags_filter, members_filter)
    "http://gdata.youtube.com/feeds/api/videos?alt=json&max-results=50" +
    '&orderby=published' +
    '&q=' + escape_query_params(members_filter) +
    '/' + escape_query_params(project_tags_filter) +
    '&fields=entry(author(name),id,published,title,content,link)'
  end

  def build_request_for_user_videos
    "http://gdata.youtube.com/feeds/api/users/#{@object.youtube_id}/uploads?alt=json&max-results=50" +
    '&fields=entry(author(name),id,published,title,content,link)'
  end

  def project_tags
    @object.tag_list.
        push(@object.title).
        map(&:downcase).
        uniq
  end

  def members_tags
    return [] if @object.members.blank?
    @object.members.map { |user| YoutubeHelper.youtube_user_name(user) if YoutubeHelper.youtube_user_name(user) }.
        compact.
        map(&:downcase).
        uniq
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
