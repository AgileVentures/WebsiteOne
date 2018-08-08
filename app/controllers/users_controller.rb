class UsersController < ApplicationController
  layout 'layouts/user_profile_layout', only: [:show]

  skip_before_action :verify_authenticity_token, :only => [:index, :show]

  before_action :get_user, only: [:show, :destroy, :add_status]
  before_action :get_user, only: [:show, :add_status]
  before_action :authenticate_user!, only: [:add_status]

  def index
    @users = users
    @users_count = @users.total_count
    @projects = Project.all.sort { |a, b| a.title <=> b.title }
    @user_type = params[:title].blank? ? 'Volunteer' : params[:title]
    @user_type = 'Premium Member' if params[:title] == 'Premium'

    respond_to do |format|
      format.js
      format.html
    end
  end

  def new
    @user = User.new(Karma.new)
    @user.status.build
  end

  def hire_me_contact_form
    message_params = params['message_form']
    request.env['HTTP_REFERER'] ||= root_path

    if message_params.nil? or
        message_params['name'].blank? or
        message_params['email'].blank? or
        message_params['message'].blank?
      redirect_back fallback_location: root_path, alert: 'Please fill in Name, Email and Message field'
    elsif !User.find(message_params['recipient_id']).display_hire_me
      redirect_back fallback_location: root_path, alert: 'User has disabled hire me button'
    elsif !Devise.email_regexp.match(message_params['email'])
      redirect_back fallback_location: root_path, alert: 'Please give a valid email address'
    elsif !message_params['fellforit'].blank?
      redirect_to :root, notice: 'Form not submitted. Are you human?'
    elsif Mailer.hire_me_form(User.find(message_params['recipient_id']), message_params).deliver_now
      redirect_back fallback_location: root_path, notice: 'Your message has been sent successfully!'
    else
      redirect_back fallback_location: root_path, alert: 'Your message has not been sent!'
    end
  end

  def show
    if should_display_user?(@user) 
      @event_instances = EventInstance.where(user_id: @user.id)
                             .order(created_at: :desc).limit(5)
      set_activity_tab(params[:tab])
    else
      raise ActiveRecord::RecordNotFound.new('User has not exposed their profile publicly')
    end
  end

  def destroy
    user = User.find(current_user.id)
    user.destroy
    flash[:notice] = 'Your account has been deactivated'
    redirect_to users_path
  end

  def add_status
    if user_has_status(params)
      @user.status.create({status: (params[:user][:status]), user_id: @user})
      flash[:notice] = 'Your status has been set'
      redirect_to user_path(@user)
    else
      flash[:alert] = 'Something went wrong...'
      render :show
    end
  end

  private

  def user_has_status(params)
    params.has_key?(:user) && params[:user].has_key?(:status)
  end

  def users
    users = User.page(params[:page]).per(15)
        .includes(:status, :titles, :karma)
        .filter(set_filter_params)
        .order("karmas.total DESC")

    users = users.allow_to_display unless privileged_visitor?
    users = users.where(email: params[:email]) if params[:email]
    users
  end

  def should_display_user?(user)
    user.display_profile || current_user == @user || privileged_visitor?
  end

  def get_user
    @user = User.friendly.find(params[:id])
  end

  def set_filter_params
    filter_params = params.slice(:project_filter, :timezone_filter, :online, :title)
    set_timezone_offset_range(filter_params)
    filter_params
  end

  def set_timezone_offset_range(filter_params)
    unless filter_params[:timezone_filter].blank?
      if offset = current_user.try(:timezone_offset)
        case filter_params[:timezone_filter]
          when 'In My Timezone'
            filter_params[:timezone_filter] = [offset, offset]
          when 'Wider Timezone Area'
            filter_params[:timezone_filter] = [offset - 3600, offset + 3600]
          else
            filter_params.delete(:timezone_filter)
        end
      else
        redirect_to :back, alert: "Can't determine your location!"
      end
    end
  end

  def set_activity_tab(param)
    return unless param.present?
    @param_tab = param
    unless UserPresenter.new(@user).contributed?
      @param_tab = nil
      flash.now[:notice] = 'User does not have activity log'
    end
  end
end
