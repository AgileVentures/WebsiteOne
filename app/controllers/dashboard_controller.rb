class DashboardController < ApplicationController
  include Statistics

  def index
    @stats = get_stats
  end

  private

  def get_stats
    stats = {}.tap do |stats|
      stats[:articles] = get_stats_for(:articles)
      stats[:projects] = get_stats_for(:projects)
      stats[:members] = get_stats_for(:members)
      stats[:documents] = get_stats_for(:documents)
    end
  end
end
