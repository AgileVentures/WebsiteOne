class EventInstancePresenter < BasePresenter
  presents :event_instance

  def started_at
    event_instance.start.strftime('%H:%M %d/%m')
  end

  def title
    event_instance.title || 'No title given'
  end

  def category
    event_instance.category || '-'
  end

  def project_link
    event_instance.project ? link_to(event_instance.project.title, url_helpers.project_path(event_instance.project)) : '-'
  end

  def event_link
    event_instance.event ? link_to(event_instance.event.name, url_helpers.event_path(event_instance.event)) : '-'
  end

  def host
    event_instance.user || NullUser.new('Anonymous')
  end

  def participants
    map_to_users(event_instance.participants)
  end

  def video_url
    if id = event_instance.yt_video_id
      "http://www.youtube.com/watch?v=#{id}&feature=youtube_gdata".html_safe
    else
      '#'
    end
  end

  def duration
    event_instance.heartbeat.present? ? distance_of_time_in_words(event_instance.heartbeat - event_instance.start) : distance_of_time_in_words(event_instance.duration_planned)
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
