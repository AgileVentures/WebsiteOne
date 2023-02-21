# frozen_string_literal: true

class PivotalTrackerUrlValidator < ActiveModel::Validator
  def validate(record)
    validate_pivotal_tracker_url(record) if record.pivotaltracker_url.present? && is_pivotal_tracker_url?(record)
  end

  private

  def validate_pivotal_tracker_url(record)
    url = record.pivotaltracker_url
    match = url.match(%r{^(?:https|http|)[:/]*www\.pivotaltracker\.com/(s|n)/projects/(\d+)$}i)
    if match.present?
      pv_id = match.captures[1]
    elsif url =~ /^\d+$/
      pv_id = url
    end

    if pv_id.present?
      # tidy up URL
      record.pivotaltracker_url = "https://www.pivotaltracker.com/n/projects/#{pv_id}"
    else
      record.errors.add(:pivotaltracker_url, 'Invalid Pivotal Tracker URL')
    end
  end

  def is_pivotal_tracker_url?(record)
    url = record.pivotaltracker_url
    match = url.match(/pivotaltracker/)
    pv_id = url =~ /^\d+$/

    !match.nil? or pv_id
  end
end
