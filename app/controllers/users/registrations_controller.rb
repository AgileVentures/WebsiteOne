class Users::RegistrationsController < Devise::RegistrationsController

  def edit
    flash[:warning] = 'Warning!'
    render :edit
  end

end