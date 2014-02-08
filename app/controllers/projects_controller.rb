class ProjectsController < ApplicationController
  layout 'with_sidebar'
  before_filter :authenticate_user!, only: [:new, :edit, :update, :destroy]
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  include DocumentsHelper

#TODO YA Add controller specs for all the code

  def index
    @projects = Project.search(params[:search], params[:page])
  end

  def show
    documents

  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params.merge("user_id" => current_user.id))
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
    #if @project.destroy
    #  @notice = 'Project was successfully deleted.'
    #else
    #  @notice = 'Project was not successfully deleted.'
    #end
    #redirect_to projects_path, notice: @notice
  end

  def follow
    set_project
    if current_user
      current_user.follow(@project)

      redirect_to project_path(@project)
      flash[:notice] = "You just joined #{@project.title}."
    else
      flash[:error] = "You must <a href='/users/sign_in'>login</a> to follow #{@project.title}.".html_safe
    end
  end

  def unfollow
    set_project

    current_user.stop_following(@project)

    redirect_to project_path(@project)
    flash[:notice] = "You are no longer a member of #{@project.title}."
  end

  private
  def set_project
    raise 'USING ID ERROR' if params[:id] =~ /^\d+$/
    begin
      @project = Project.friendly.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to projects_path, alert: 'Requested action failed.  Project was not found.'
    end
  end



  def project_params
    # permit the mass assignments
    params.require(:project).permit(:title, :description, :created, :status, :user_id)
  end



end
