# frozen_string_literal: true

class DashboardController < ApplicationController
  include Statistics
  def index
    @stats = get_stats
    @activities = get_activities
  end

  private

  def get_stats
    stats = {}.tap do |stats|
      stats[:articles] = get_stats_for(:articles)
      stats[:projects] = get_stats_for(:projects)
      stats[:members] = get_stats_for(:members)
      stats[:documents] = get_stats_for(:documents)
      stats[:pairing_minutes] = get_stats_for(:pairing_minutes)
      stats[:scrum_minutes] = get_stats_for(:scrum_minutes)
      stats[:map_data] = User.map_data
    end
  end

  def get_activities
    activities = PublicActivity::Activity.order('created_at desc').where(owner_type: 'User').limit(100)
    errorous_activities = activities.select { |act| act.owner&.gravatar_url.nil? || act.owner.nil? }
    if errorous_activities.empty?
      activities
    else
      errorous_activities.each do |activity|
        activity.destroy!
      end
      get_activities
    end
  end
end
