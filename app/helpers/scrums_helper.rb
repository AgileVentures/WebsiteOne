module ScrumsHelper
  def scrum_link(video)
    link_to raw('<a class="btn btn-default btn-danger btn-xs"><span class="glyphicon glyphicon-play"></span></a>'), video[:url], id: video[:id], class: 'yt_link', data: { content: video[:content], toggle: "modal", target: "#player" }
  end

  def scrum_embed_link(video)
    "http://www.youtube.com/embed/#{video[:id]}?enablejsapi=1"
  end
end
