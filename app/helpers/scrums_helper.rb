module ScrumsHelper
  def scrum_link(video)
    link_to(
      raw('<i class="fa fa-bg fa-play"></i>') + video[:title],
      video[:url], {
        id: video[:id],
        class: 'scrum_yt_link',
        data: { content: video[:content], toggle: 'modal', target: '#player' }
      }
    )
  end

  def scrum_embed_link(video)
    "http://www.youtube.com/embed/#{video[:id]}?enablejsapi=1"
  end
end
