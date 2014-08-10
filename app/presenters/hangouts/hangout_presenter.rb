require_relative '../base_presenter'

class HangoutPresenter < BasePresenter
  presents :hangout

  def created_at
    hangout.created_at.to_s(:time)
  end

  def title
    hangout.title || 'No title given'
  end

  def project_name
    hangout.project.try!(:title) || '-'
  end

  def event_name
    hangout.event.try!(:name) || '-'
  end

  def host
    hangout.host || NullUser.new('Anonymous')
  end

  def participants
    if participants = hangout.participants
      participants.map do |participant|
        User.find_by_youtube_id(participant[:gplus_id]) || NullUser.new(participant[:name])
      end
    else
      []
    end
  end

  def video_url
    if id = hangout.yt_video_id
      "http://www.youtube.com/watch?v=#{id}&feature=youtube_gdata".html_safe
    else
      '#'
    end
  end

end
