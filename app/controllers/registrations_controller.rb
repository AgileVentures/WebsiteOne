class RegistrationsController < Devise::RegistrationsController
  layout 'layouts/user_profile_layout', only: [:edit]

  def create
    super
    unless @user.new_record?
      session[:omniauth] = nil
      Mailer.send_welcome_message(@user).deliver_now if Features.enabled?(:welcome_email)
    end
  end

  def update
    if params[:preview]
      resource.display_email = params[:user][:display_email] == '1'
      render action: 'edit'
    else
      @user = User.friendly.find(current_user.friendly_id)
      @user.skill_list = params[:user].delete 'skill_list' # Extracts skills from params
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

  def build_resource(hash = nil)
    self.resource = User.new_with_session(hash || {}, session)
    if session[:omniauth]
      @user.apply_omniauth(session[:omniauth])
      @user.valid?
    end
  end

  def after_update_path_for(resource)
    user_path(resource)
  end
end
