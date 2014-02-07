class UsersController < ApplicationController

  def index
    @users = User.all #.order(last_name: :desc, first_name: :desc)
  end

  def show
    @user = User.find(params[:id])
  end

  # def generate_preview
  # 	session[:display_email] = params[:display_email]
  # 	render :js => "window.location = '/users/preview/"+current_user.id.to_s+"'"
  #   # redirect_to users_preview_path
  # end

  def preview
  	@user = current_user
  end


end
