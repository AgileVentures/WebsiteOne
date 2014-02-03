class UsersController < ApplicationController

  def index
    @users = User.all #.order(last_name: :desc, first_name: :desc)
  end

  def show
  end

end
