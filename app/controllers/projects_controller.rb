class ProjectsController < ApplicationController
  def index
    @projects = Project.all
    render 'index'
  end

  def show
    render 'show'
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
      if @project.save
         redirect_to @project, notice: 'Project was successfully created.'
      else
         render action: 'new'
      end
  end

  def edit
    puts "EDIT" + params.inspect
  end
  private
  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:title, :description, :created, :status)
  end

end
