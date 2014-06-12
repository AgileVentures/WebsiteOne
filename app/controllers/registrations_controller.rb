class RegistrationsController < Devise::RegistrationsController
  def create
    super
    session[:omniauth] = nil unless @user.new_record?
    Mailer.send_welcome_message(@user).deliver unless @user.new_record?
  end

  def update
    if params[:preview]
      resource.display_email = params[:user][:display_email] == '1'
      render :action => 'edit'
    else
      @user = User.friendly.find(current_user.friendly_id)
      @user.skill_list = params[:user].delete "skill_list" # Extracts skills from params
      account_update_params = devise_parameter_sanitizer.sanitize(:account_update)

      if @user.update_attributes(account_update_params)
        set_flash_message :notice, :updated
        redirect_to after_update_path_for(@user)
      else
        render :edit
      end
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

  def after_update_path_for(resource)
    user_path(resource)
  end
end