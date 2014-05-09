module ScrumsHelper
  def scrum_link(video)
    link_to video, video['url'], id: video, class: 'yt_link', data: { content: video['content']}
  end

  def scrum_embed_link(video)
    "http://www.youtube.com/embed/#{video}?enablejsapi=1"
  end
end
