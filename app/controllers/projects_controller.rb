class ProjectsController < ApplicationController
  def index
    @projects = Project.all
    render 'index'
  end

  def new

  end
end
