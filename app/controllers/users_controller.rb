class UsersController < ApplicationController
  include Youtube

  def index
    @users = User.where('display_profile = ?', true) #.order(last_name: :desc, first_name: :desc)
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
