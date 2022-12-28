# frozen_string_literal: true

module ScrumsHelper
  def scrum_link(video)
    video.yt_video_id ? link_video(video) : display_error(video)
  end

  def link_video(video)
    link_to(
      raw('<i class="fa fa-bg fa-play"></i>') + video[:title],
      '#', {
        id: video[:id],
        class: 'scrum_yt_link',
        data: { content: video[:title], source: video[:yt_video_id], toggle: 'modal', target: '#scrumVideo' }
      }
    )
  end

  def display_error(video)
    "#{video[:title]}\n - There is no recording of the event available"
  end
end
