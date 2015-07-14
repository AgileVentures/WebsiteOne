module ScrumsHelper
  def scrum_link(video)
    link_to(
      raw('<i class="fa fa-bg fa-play"></i>') + video[:title],
      '#', {
        id: video[:id],
        class: 'scrum_yt_link',
        data: { content: video[:title], source: video[:yt_video_id], toggle: 'modal', target: '#scrumVideo' }
      }
    )
  end

end
