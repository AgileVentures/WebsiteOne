class UsersController < ApplicationController
  include Youtube

  def index
    @users = User.where('display_profile = ?', true).order(:created_at)
  end

  def hire_me_contact_form
    begin
      #debugger
      test = params['message_form']
      if test['name'].empty? or test['message'].empty?
        redirect_to :back, alert: 'Please, fill in Name and Message field'
        return
      end

      if Mailer.hire_me_form(params).deliver
        redirect_to :back, notice: 'Your message has been sent successfully!'
      else
        redirect_to :back, alert: 'Your message has not been sent!'
      end



    rescue ActionController::RedirectBackError
      redirect_to :back
    end
  end

  def show
    raise 'Deprecated Numeric ID' if params[:id] =~ /^\d+$/
    @user = User.friendly.find(params[:id])

    @users_projects = @user.following_by_type('Project')

    if !@user.display_profile  && (current_user.try(&:id) != @user.id)
      #TODO Marcelo implement a 404 error once we implement custom name errors
      flash[:notice] = 'User has set his profile to private'
      redirect_to root_path
    else
      videos = Youtube.user_videos(@user) if @user
      if videos
        @youtube_videos = videos.select do |hash|
          #hash[:title] =~ /Pairing session/
          true
        end
      end
    end
  end
end
