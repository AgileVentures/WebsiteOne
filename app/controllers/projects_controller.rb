class ProjectsController < ApplicationController
  layout 'with_sidebar'
  before_filter :authenticate_user!, except: [:index, :show]
  before_action :set_project, except: [:index, :new, :create]
  before_action :set_project_documents, only: :show
  before_action :get_current_stories, only: [:show]

  def index
    @projects = Project.search(params[:search], params[:page])
    render layout: 'with_sidebar_sponsor_right'
  end

  def show
    @members = @project.members
    @videos = @project.videos if @project
  end

  def new
    @project = Project.new
  end

  def create
    @project = current_user.projects.build(project_params)
    if @project.save
      redirect_to project_path(@project), notice: 'Project was successfully created.'
    else
      flash.now[:alert] = 'Project was not saved. Please check the input.'
      render 'new'
    end
  end

  def edit
  end

  def update
    if @project.update_attributes(project_params)
      redirect_to project_path(@project), notice: 'Project was successfully updated.'
    else
      # TODO change this to notify for invalid params
      flash.now[:alert] = 'Project was not updated.'
      render 'edit'
    end
  end


  # def destroy
  #   if @project.destroy
  #     @notice = 'Project was successfully deleted.'
  #   else
  #     @notice = 'Project was not successfully deleted.'
  #   end
  #   redirect_to projects_path, notice: @notice
  # end

  def follow
    if current_user
      current_user.follow(@project)
      flash[:notice] = "You just joined #{@project.title}."
    else
      flash[:error] = "You must <a href='/users/sign_in'>login</a> to follow #{@project.title}.".html_safe
    end
    redirect_to project_path(@project)
  end

  def unfollow
    if current_user
      current_user.stop_following(@project)
      flash[:notice] = "You are no longer a member of #{@project.title}."
    else
      flash[:error] = "You must <a href='/users/sign_in'>login</a> to unfollow #{@project.title}.".html_safe
    end
    redirect_to project_path(@project)
  end

  private
  def set_project
    @project = Project.friendly.find(params[:id])
  end

  def set_project_documents
    @documents = Document.where("project_id = ?", @project.id).order(:created_at)
  end

  def get_current_stories
    PivotalService.set_token('1e90ef53f12fc327d3b5d8ee007cce39')
    if @project.pivotaltracker_url?
      pivotaltracker_id = @project.pivotaltracker_url.split('/')[-1]
      begin
        @projectpv = PivotalService.one_project(pivotaltracker_id, Scorer::Project.fields)
        @iteration = PivotalService.iterations(pivotaltracker_id, 'current')
        @stories = @iteration.stories
      rescue => error
        # TODO deal with simple not found errors, should not send for all exceptions
        ExceptionNotifier.notify_exception(error, env: request.env, :data => { message: 'an error occurred in Pivotal Tracker' })
      end
    end
    @stories ||= []
  end

  def project_params
    # permit the mass assignments
    params.require(:project).permit(:title, :description, :created, :status, :user_id, :github_url, :pivotaltracker_url, :pivotaltracker_id)
  end

end
