class DashboardController < ApplicationController
  def index
    @stats = get_stats
  end

  private

  def get_stats
    stats = {}.tap do |stats|
      stats[:articles] = get_stats_for(:articles)
      stats[:projects] = get_stats_for(:projects)
      stats[:members] = get_stats_for(:members)
    end
  end

  def get_stats_for(entity)
    stats = {}.tap do |stats|
      case entity
      when :articles then
        stats[:count] = Article.count
      when :projects then
        stats[:count] = Project.count
      when :members then
        stats[:count] = User.count
      end
    end
  end
end
