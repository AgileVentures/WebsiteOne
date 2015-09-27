class PivotalTrackerUrlValidator < ActiveModel::Validator
  def validate(record)
    validate_pivotal_tracker_url(record) if record.pivotaltracker_url.present?
  end

  private

  def validate_pivotal_tracker_url(record)
    url = record.pivotaltracker_url
    match = url.match(/^(?:https|http|)[:\/]*www\.pivotaltracker\.com\/s\/projects\/(\d+)$/i)
    if match.present?
      pv_id = match.captures[0]
    elsif url =~ /^\d+$/
      pv_id = url
    end

    if pv_id.present?
      # tidy up URL
      record.pivotaltracker_url = "https://www.pivotaltracker.com/s/projects/#{pv_id}"
    else
      record.errors[:pivotaltracker_url] << 'Invalid Pivotal Tracker URL'
    end
  end
end
