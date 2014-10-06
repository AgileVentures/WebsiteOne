class UsersController < ApplicationController
  def index
    @users = User.search(params)
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
    elsif !message_params['fellforit'].blank?
      redirect_to :root, notice: 'Form not submitted. Are you human?'
    elsif Mailer.hire_me_form(User.find(message_params['recipient_id']), message_params).deliver
      redirect_to :back, notice: 'Your message has been sent successfully!'

    else
      redirect_to :back, alert: 'Your message has not been sent!'
    end
  end

  def show
    @user = User.friendly.find(params[:id])

    if should_display_user?(@user)
      @youtube_videos  = YoutubeVideos.for(@user).first(5)
    else
      raise ActiveRecord::RecordNotFound.new("User has not exposed his profile publicly")
    end
  end

  private

  def should_display_user?(user)
    user.display_profile || current_user == @user
  end
end
