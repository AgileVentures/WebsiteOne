class ProjectsController < ApplicationController

  layout 'with_sidebar'
  before_filter :authenticate_user!, except: [:index, :show]
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :get_current_stories, only: [:show]
  include DocumentsHelper

#TODO YA Add controller specs for all the code

  def index
    @projects = Project.order('status ASC').order('commit_count DESC NULLS LAST').search(params[:search], params[:page]).includes(:user)
    #binding.pry
    render layout: 'with_sidebar_sponsor_right'
  end

  def show
    documents
    @members = @project.members
    relation = EventInstance.where(project_id: @project.id)
    @event_instances_count = relation.count
    @event_instances = relation.order(created_at: :desc).limit(25)
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params.merge('user_id' => current_user.id))
    if @project.save
      add_to_feed(:create)
      redirect_to project_path(@project), notice: 'Project was successfully created.'
    else
      flash.now[:alert] = 'Project was not saved. Please check the input.'
      render action: 'new'
    end
  end

  def edit
  end

  def update
    if @project.update_attributes(project_params)
      add_to_feed(:update)
      redirect_to project_path(@project), notice: 'Project was successfully updated.'
    else
      # TODO change this to notify for invalid params
      flash.now[:alert] = 'Project was not updated.'
      render 'edit'
    end
  end

  def mercury_update
    set_project
    @project.update_attributes(pitch: params[:content][:pitch_content][:value])
    add_to_feed(:update)
    render text: ''
  end

  def mercury_saved
    @project = Project.find_by_slug(params[:id])
    redirect_to project_path(@project), notice: 'The project has been successfully updated.'
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
    @project = Project.friendly.find(params[:id])
  end

  def add_to_feed(action)
    @project.create_activity action, owner: current_user
  end

  def get_current_stories
    PivotalService.set_token('1e90ef53f12fc327d3b5d8ee007cce39')
    if @project.pivotaltracker_url.present?
      pivotaltracker_id = @project.pivotaltracker_url.split('/')[-1]
      begin
        @projectpv = PivotalService.one_project(pivotaltracker_id, Scorer::Project.fields)
        @iteration = PivotalService.iterations(pivotaltracker_id, 'current')
        @stories = @iteration.stories
      rescue Exception => error
        # TODO deal with simple not found errors, should not send for all exceptions
        ExceptionNotifier.notify_exception(error, env: request.env, :data => { message: 'an error occurred in Pivotal Tracker' })
      end
    end
    @stories ||= []
  end

  def project_params
    params.require(:project).permit(:title, :description, :pitch, :created, :status, :user_id, :github_url, :pivotaltracker_url, :pivotaltracker_id, :image_url)
  end
end
