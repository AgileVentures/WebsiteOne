class RegistrationsController < Devise::RegistrationsController
  def create
    super
    session[:omniauth] = nil unless @user.new_record?
  end

  def update
    account_update_params = devise_parameter_sanitizer.sanitize(:account_update)

    # Bryan: creates a new but identical object
    @user = User.find(current_user.id)
    if @user.password_required?
      unless @user.valid_password?(account_update_params[:current_password])
        render 'edit'
        return
      end
    else
      # TODO Bryan: find a way to authenticate with third party libraries
    end

    if @user.update_attributes(account_update_params)
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case his password changed
      sign_in current_user, :bypass => true
      redirect_to after_update_path_for(@user)
    else
      render 'edit'
    end
  end

  private

  def build_resource(*args)
    super
    if session[:omniauth]
      @user.apply_omniauth(session[:omniauth])
      @user.valid?
    end
  end
end