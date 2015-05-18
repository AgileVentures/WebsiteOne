class EventInstancePresenter < BasePresenter
  presents :event_instance

  def created_at
    event_instance.created_at.strftime('%H:%M %d/%m')
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
    distance_of_time_in_words(event_instance.duration)
  end

  def video_link
    if yt_video_id.present?
      link_to title, video_url, id: yt_video_id, class: 'yt_link', data: { content: title }
    end
  end

  def video_embed_link
    if yt_video_id.present?
      "http://www.youtube.com/embed/#{yt_video_id}?enablejsapi=1"
    end
  end

  private

  def map_to_users(participants)
    participants ||= []

    participants.map do |participant|
      begin
        person = participant.last[:person]
        user = Authentication.find_by(provider: 'gplus', uid: person[:id]).try!(:user)
        next if user == host
        user || NullUser.new(person[:displayName])
      rescue NoMethodError
        Rails.logger.error "Exception at event_instance_presenter#map_to_users"
        nil
      end
    end.compact
  end
end
