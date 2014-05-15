module YoutubeApi
  extend self

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

  def followed_project_tags(user)
    projects = user.following_by_type('Project')
    [].tap do |tags|
      projects.each do |project|
        tags.concat(project_tags(project))
      end
      tags << 'scrum'
      tags.uniq!
    end
  end

  def build_request(type, *args) # members_filter=nil, project_tags_filter=nil
    call_type = (type == :project ? 'videos' : "users/#{args[0].youtube_id}/uploads")
    request = "http://gdata.youtube.com/feeds/api/#{call_type}?alt=json&max-results=50"
    if type == :project
      request += '&orderby=published'
      request += '&q=(' + args[1].join('|') + ')'
      request += '/(' + args[0].join('|') + ')'
    end
    request += '&fields=entry(author(name),id,published,title,content,link)'
  end

  def project_tags(project)
    project.tag_list.
        push(project.title).
        map(&:downcase).
        uniq
  end

  def members_tags(members)
    return [] if members.blank?
    members.map { |user| YoutubeHelper.youtube_user_name(user) if YoutubeHelper.youtube_user_name(user) }.
        compact.
        map(&:downcase).
        uniq
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