class UsersController < ApplicationController
  layout 'layouts/user_profile_layout', only: [:show]

  before_filter :get_user, only: [:show, :add_status]
  before_filter :authenticate_user!, only: [:add_status]

  def index
    @users = User.filter(set_filter_params).allow_to_display.by_create
    @users_count = User.allow_to_display.count
    @projects = Project.all
  end

  def new
    @user = User.new
    @user.status.build
  end

  def hire_me_contact_form
    message_params = params['message_form']
    request.env['HTTP_REFERER'] ||= root_path

    if message_params.nil? or
        message_params['name'].blank? or
        message_params['email'].blank? or
        message_params['message'].blank?
      redirect_to :back, alert: 'Please fill in Name, Email and Message field'
    elsif !User.find(message_params['recipient_id']).display_hire_me
      redirect_to :back, alert: 'User has disabled hire me button'
    elsif !Devise.email_regexp.match(message_params['email'])
      redirect_to :back, alert: 'Please give a valid email address'
    elsif !message_params['fellforit'].blank?
      redirect_to :root, notice: 'Form not submitted. Are you human?'
    elsif Mailer.hire_me_form(User.find(message_params['recipient_id']), message_params).deliver
      redirect_to :back, notice: 'Your message has been sent successfully!'

    else
      redirect_to :back, alert: 'Your message has not been sent!'
    end
  end

  def show
    if should_display_user?(@user)
      @youtube_videos = YoutubeVideos.for(@user).first(5)
    else
      raise ActiveRecord::RecordNotFound.new('User has not exposed his profile publicly')
    end
  end

  def add_status
    unless params[:user][:status].blank?
      @user.status.create({status: (params[:user][:status]), user_id: @user})
      flash[:notice] = 'Your status has been set'
      redirect_to user_path(@user)
    else
      flash[:alert] = 'Something went wrong...'
      render :show
    end
  end


  private

  def should_display_user?(user)
    user.display_profile || current_user == @user
  end

  def get_user
    @user = User.friendly.find(params[:id])
  end

  def set_filter_params
    filter_params = params.slice(:project_filter, :timezone_filter, :online)
    set_timezone_degree_range(filter_params)
    filter_params
  end

  def set_timezone_degree_range(filter_params)
    unless filter_params[:timezone_filter].blank?
      if lng = @current_user.try(:longitude)
        case filter_params[:timezone_filter]
        when 'Close To My Timezone Area'
          filter_params[:timezone_filter] = [lng - 7.5, lng + 7.5]
        when 'Wider Timezone Area'
          filter_params[:timezone_filter] = [lng - 22.5, lng + 22.5]
        end
      else
        redirect_to :back, alert: "Can't determine your location!"
      end
    end
  end
end
