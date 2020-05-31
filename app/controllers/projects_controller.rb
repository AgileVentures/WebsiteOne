class ProjectsController < ApplicationController
  layout 'with_sidebar'
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_project, only: [:show, :edit, :update]
  before_action :get_current_stories, only: [:show]
  include DocumentsHelper

#TODO YA Add controller specs for all the code

  def index
    initialize_projects
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

  def follow
    set_project
    if current_user
      current_user.follow(@project)
      send_email_notifications
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

  def send_email_notifications
    ProjectMailer.with(project: @project, user: current_user, project_creator: @project.user).
        alert_project_creator_about_new_member.deliver_now if @project.user.receive_mailings

    ProjectMailer.with(project: @project, user: current_user, project_creator: @project.user).
        welcome_project_joinee.deliver_now if current_user.receive_mailings
  end

  def set_project
    @project = Project.friendly.find(params[:id])
  end

  def initialize_projects
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
                                    name_ids: [], source_repositories_attributes: [:id, :url, :_destroy],
                                    issue_trackers_attributes: [:id, :url, :_destroy])
  end
end
