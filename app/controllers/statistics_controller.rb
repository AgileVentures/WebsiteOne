class StatisticsController < ApplicationController
  def index
     get_article_count 
     get_project_count
     get_member_count
     render 'dashboard/index'
  end

  def init_stats
     @stats ||= Hash.new
  end

  def get_article_count
    init_stats
    @stats[:articles] ||= {}
    @stats[:articles][:count] = Article.count
    @stats
  end

  def get_project_count
    init_stats
    @stats[:projects] ||= {}
    @stats[:projects][:count] = Project.count
    @stats
  end

  def get_member_count
    init_stats
    @stats[:members] ||= {}
    @stats[:members][:count] = User.count
    @stats
  end
  # Document.count 17
  # Event.count 2
end
