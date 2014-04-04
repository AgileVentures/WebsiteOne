class UsersController < ApplicationController
  include Youtube

  def index
    @users = User.where('display_profile = ?', true).order(:created_at)
  end

  def hire_me_contact_form
    message_params = params['message_form']
    request.env['HTTP_REFERER'] ||= root_path

    if message_params.nil? or
        message_params['name'].blank? or
        message_params['email'].blank? or
        message_params['message'].blank?
      redirect_to :back, alert: 'Please fill in Name, Email and Message field'

    elsif Mailer.hire_me_form(User.find(message_params['recipient_id']), message_params).deliver
      redirect_to :back, notice: 'Your message has been sent successfully!'

    else
      redirect_to :back, alert: 'Your message has not been sent!'
    end
  end

  def show
    @user = User.friendly.find(params[:id])
    @skills = @user.skill_list
    @users_projects = @user.following_by_type('Project')

    if !@user.display_profile  && (current_user.try(&:id) != @user.id)
      flash[:notice] = 'User has set his profile to private'
      redirect_to root_path
    else
      @youtube_videos  = Youtube.user_videos(@user) if @user
    end
  end
end
