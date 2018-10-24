class ProjectsController < ApplicationController
  layout 'with_sidebar'
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :get_current_stories, only: [:show]
  include DocumentsHelper

#TODO YA Add controller specs for all the code

  def index
    initialze_projects
    @projects_languages_array = Language.pluck(:name)
    filter_projects_list_by_language if params[:project]
    @projects = @projects.search(params[:search], params[:page])
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
    @project.source_repositories.build
    @project.languages.build
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
      @project.send_notification_to_project_creator(current_user)
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

  def initialze_projects
    @projects = Project.order('status ASC')
                       .order('last_github_update DESC NULLS LAST')
                       .order('commit_count DESC NULLS LAST')
                       .includes(:user)
  end

  def filter_projects_list_by_language
    @language = params[:project][:languages]
    @projects = @projects.search_by_language(@language)
  end

  def add_to_feed(action)
    @project.create_activity action, owner: current_user
  end

  def get_current_stories
    PivotalAPI::Service.set_token('1e90ef53f12fc327d3b5d8ee007cce39')
    @is_non_pt_issue_tracker = false
    if @project.pivotaltracker_url.present?
      pivotaltracker_id = @project.pivotaltracker_url.split('/')[-1]
      begin
        project = PivotalAPI::Project.retrieve(pivotaltracker_id)
        iteration = project.current_iteration
        @stories = iteration.stories
      rescue Exception => error
        # TODO deal with simple not found errors, should not send for all exceptions
        ExceptionNotifier.notify_exception(error, env: request.env, :data => { message: 'an error occurred in Pivotal Tracker' })
        @is_non_pt_issue_tracker = true
      end
    end
    @stories ||= []
  end

  def project_params
    params.require(:project).permit(:title, :description, :pitch, :created, :status,
                                    :user_id, :github_url, :pivotaltracker_url, :slack_channel_name,
                                    :pivotaltracker_id, :image_url, languages_attributes: [:name],
                                    name_ids: [], source_repositories_attributes: [:id, :url, :_destroy])
  end
end
