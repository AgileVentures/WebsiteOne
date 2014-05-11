module ScrumsHelper
  def scrum_link(video)
    link_to video[:title], video[:url], id: video[:id], class: 'yt_link', data: { content: video[:content] }
  end

  def scrum_embed_link(video)
    "http://www.youtube.com/embed/#{video[:id]}?enablejsapi=1"
  end
end
