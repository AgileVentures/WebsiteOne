class UsersController < ApplicationController

  def index
    @users = User.where('display_profile = ?', true) #.order(last_name: :desc, first_name: :desc)
  end

  def show
    @user = User.find(params[:id])
    if (current_user.try(&:id) != @user.id) && !@user.display_profile
        #TODO Marcelo implement a 404 error once we implement custom name errors
      flash[:notice] = 'User has set his profile to private'
      redirect_to root_path
    end
  end
end
