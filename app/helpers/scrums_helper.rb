module ScrumsHelper
  def scrum_link(video)
    link_to(
      raw('<span class="glyphicon glyphicon-play"></span>'),
      video[:url], {
        id: video[:id],
        class: 'yt_link btn btn-default btn-danger btn-xs',
        data: { content: video[:content], toggle: "modal", target: "#player" }
      }
    )
    puts "lol"
  end

  def scrum_embed_link(video)
    "http://www.youtube.com/embed/#{video[:id]}?enablejsapi=1"
  end
end
