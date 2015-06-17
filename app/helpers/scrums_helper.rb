module ScrumsHelper
  def scrum_link(video)
    link_to(
      raw('<i class="fa fa-bg fa-play"></i>') + video[:title],
      video[:yt_video_id], {
        id: video[:id],
        class: 'scrum_yt_link',
        data: { content: video[:title], toggle: 'modal', target: '#scrumVideo' }
      }
    )
  end

  def scrum_embed_link(video)
    "http://www.youtube.com/embed/#{video[:yt_video_id]}?enablejsapi=1"
  end
end
