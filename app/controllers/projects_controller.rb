class ProjectsController < ApplicationController
  def index
    @projects = Project.all
    render 'projects'
  end
end
