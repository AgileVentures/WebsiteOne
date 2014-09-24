class HangoutPresenter < BasePresenter
  presents :hangout

  def created_at
    hangout.created_at.strftime('%H:%M %d/%m')
  end

  def title
    hangout.title || 'No title given'
  end

  def category
    hangout.category || '-'
  end

  def project_link
    hangout.project ? link_to(hangout.project.title, url_helpers.project_path(hangout.project)) : '-'
  end

  def event_link
    hangout.event ? link_to(hangout.event.name, url_helpers.event_path(hangout.event)) : '-'
  end

  def host
    hangout.user || NullUser.new('Anonymous')
  end

  def participants
    map_to_users(hangout.participants)
  end

  def video_url
    if id = hangout.yt_video_id
      "http://www.youtube.com/watch?v=#{id}&feature=youtube_gdata".html_safe
    else
      '#'
    end
  end

  def duration
    distance_of_time_in_words(hangout.duration)
  end

  private

  def map_to_users(participants)
    participants ||= []

    participants.map do |participant|
      person = participant.last[:person]
      user = Authentication.find_by(provider: 'gplus', uid: person[:id]).try!(:user)
      next if user == host
      user || NullUser.new(person[:displayName])
    end.compact
  end

end
