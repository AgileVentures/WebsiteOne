class ProjectsController < ApplicationController
  def index
    @projects = Project.all
    render 'index'
  end

  def show
    set_project
    #render 'show'
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
    set_project
  end

  def update
    set_project
    # @project.status = "undetermined"
    # @project.save!
    if @project.update_attributes(project_params)
      redirect_to @project, notice: 'Project was successfully updated.'
    else
      # TODO change this to notify for invalid params
      render 'edit', notice: 'Project was not updated.'
    end
  end

  
  private
  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:title, :description, :created, :status)
  end

end
