class Users::RegistrationsController < Devise::RegistrationsController

  def edit
    flash[:warning] = 'There was an error updating your account.'
    render :edit
  end

end
