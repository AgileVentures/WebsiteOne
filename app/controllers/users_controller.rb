class UsersController < ApplicationController

  def index
    @users = User.all #.order(last_name: :desc, first_name: :desc)
  end

  def show
    @user = User.find(params[:id])
    @users_projects = @user.following_by_type('Project')
  end

end
