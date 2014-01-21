class ProjectsController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :edit, :update, :destroy]
  before_action :set_project, only: [:show, :edit, :update, :destroy]

#TODO YA Add controller specs for all the code

  def index
    @projects = Project.all
  end

  def show
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
      if @project.save
        redirect_to projects_path, notice: 'Project was successfully created.'
      else
        flash.now[:alert] = 'Project was not saved. Please check the input.'
        render action: 'new'
      end
  end

  def edit
  end

  def update
    if @project.update_attributes(project_params)
      redirect_to projects_path, notice: 'Project was successfully updated.'
    else
      # TODO change this to notify for invalid params
      flash.now[:alert] =  'Project was not updated.'
      render 'edit'
    end
  end



  def destroy
    if @project.destroy
      @notice = 'Project was successfully deleted.'
    else
      @notice = 'Project was not successfully deleted.'
    end
    redirect_to projects_path, notice: @notice
  end



  private
  def set_project
    begin
      @project = Project.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to projects_path, alert: 'Requested action failed.  Project was not found.'
    end

  end

  def project_params
    # permit the mass assignments
    params.require(:project).permit(:title, :description, :created, :status)
  end

end
