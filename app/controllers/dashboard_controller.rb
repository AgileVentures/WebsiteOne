# frozen_string_literal: true

class DashboardController < ApplicationController
  include Statistics

  def index
    @stats = get_stats
    @activities = PublicActivity::Activity.order('created_at desc').where(owner_type: 'User').limit(100)
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
end
