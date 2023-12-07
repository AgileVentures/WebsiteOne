class YouTubeRails
  URL_FORMATS = {
      regular: /^(https?:\/\/)?(www\.)?youtube.com\/watch\?(.*\&)?v=(?<id>[^&]+)/,
      shortened: /^(https?:\/\/)?(www\.)?youtu.be\/(?<id>[^&]+)/,
      embed: /^(https?:\/\/)?(www\.)?youtube.com\/embed\/(?<id>[^&]+)/,
      embed_as3: /^(https?:\/\/)?(www\.)?youtube.com\/v\/(?<id>[^?]+)/,
      chromeless_as3: /^(https?:\/\/)?(www\.)?youtube.com\/apiplayer\?video_id=(?<id>[^&]+)/
  }

  INVALID_CHARS = /[^a-zA-Z0-9\:\/\?\=\&\$\-\_\.\+\!\*\'\(\)\,]/

  def self.has_invalid_chars?(youtube_url)
    !INVALID_CHARS.match(youtube_url).nil?
  end

  def self.extract_video_id(youtube_url)
    return nil if has_invalid_chars?(youtube_url)

    URL_FORMATS.values.inject(nil) do |result, format_regex|
      match = format_regex.match(youtube_url)
      match ? match[:id] : result
    end
  end

  def self.youtube_embed_url(youtube_url, width = 420, height = 315, **options)
    %(<iframe width="#{width}" height="#{height}" src="#{ youtube_embed_url_only(youtube_url, **options) }" frameborder="0" allowfullscreen></iframe>)
  end

  def self.youtube_regular_url(youtube_url, **options)
    vid_id = extract_video_id(youtube_url)
    "http#{'s' if options[:ssl]}://www.youtube.com/watch?v=#{ vid_id }"
  end

  def self.youtube_shortened_url(youtube_url, **options)
    vid_id = extract_video_id(youtube_url)
    "http#{'s' if options[:ssl]}://youtu.be/#{ vid_id }"
  end

  def self.youtube_embed_url_only(youtube_url, **options)
    vid_id = extract_video_id(youtube_url)
    "http#{'s' if options[:ssl]}://www.youtube.com/embed/#{ vid_id }#{'?rel=0' if options[:disable_suggestion]}"
  end

  def self.extract_video_image(youtube_url, version = 'default')
    vid_id = extract_video_id(youtube_url)
    case version
      when 'default'
        "https://i.ytimg.com/vi/#{ vid_id }/default.jpg"
      when 'medium'
        "https://i.ytimg.com/vi/#{ vid_id }/mqdefault.jpg"
      when 'high'
        "https://i.ytimg.com/vi/#{ vid_id }/hqdefault.jpg"
      when 'maximum'
        "https://i.ytimg.com/vi/#{ vid_id }/sddefault.jpg"
    end
  end
end
