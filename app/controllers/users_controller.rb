class UsersController < ApplicationController
  layout 'layouts/user_profile_layout', only: [:show]

  skip_before_action :verify_authenticity_token, :only => [:index, :show]

  before_action :get_user, only: [:show, :destroy, :add_status]
  before_action :get_user, only: [:show, :add_status]
  before_action :authenticate_user!, only: [:add_status]

  def index
    @users = users
    @users_count = @users.total_count
    @projects = Project.where(status: "active").sort { |a, b| a.title <=> b.title }
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
    message_params = params.fetch(:message_form, {})
    request.env['HTTP_REFERER'] ||= root_path
    contact_form = ContactForm.new(name: message_params['name'],
                                   email: message_params['email'],
                                   message: message_params['message'])

    if contact_form.valid?
      if Mailer.hire_me_form(User.find(message_params['recipient_id']), message_params).deliver_now
      redirect_back fallback_location: root_path, notice: 'Your message has been sent successfully!'
      else
        redirect_back fallback_location: root_path, alert: 'Your message has not been sent!'
      end
    else
      flash[:alert] = contact_form.errors.full_messages
      redirect_back fallback_location: root_path
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
    filter_params = params.slice(:project_filter, :online, :title)
    filter_params
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
