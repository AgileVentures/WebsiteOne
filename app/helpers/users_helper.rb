require 'open-uri'

module UsersHelper
  def link_to_youtube_button(origin_url)
    link_to raw('<i class="fa fa-youtube"></i> Sync with YouTube'),
            "/auth/gplus/?youtube=true&origin=#{CGI.escape origin_url}", class: 'btn btn-block btn-social btn-danger', type: 'button'
  end

  def unlink_from_youtube_button(origin_url)
    link_to raw('<i class="fa fa-youtube"></i> Disconnect YouTube'),
            "/auth/destroy/youtube?origin=#{CGI.escape origin_url}", class: 'btn btn-block btn-social btn-danger', type: 'button'
  end

  def video_link(video)
    link_to video[:title], video[:url], id: video[:id], class: 'yt_link', data: { content: video[:content] }
  end

  def video_embed_link(video)
    "http://www.youtube.com/embed/#{video[:id]}?enablejsapi=1"
  end
end

