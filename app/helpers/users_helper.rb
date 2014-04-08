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