class CreateAuthenticationService
  def initialize(omniauth, user)
    user.authentications.create(:provider => omniauth['provider'], :uid => omniauth['uid'])
    user.update(email: omniauth['info']['email']) unless user.email?
  end

  def create_new_authentication_for_current_user(path)
    if create_authentication_for_user
      # Bryan: TESTED
      flash[:notice] = 'Authentication successful.'
      redirect_to path
    else
      # Bryan: TESTED
      flash[:alert] = 'Unable to create additional profiles.'
      redirect_to redirect_path
    end
 end

  def create_new_user_with_authentication
    #if new user could be created
    if user.save
      # Bryan: TESTED
      flash[:notice] = 'Signed in successfully.'
      sign_in_and_redirect(:user, user)
    else
      # Bryan: TESTED
      session[:omniauth] = omniauth.except('extra')
      redirect_to new_user_registration_url
    end
  end

  def after_action_stuff
    if omniauth['provider']=='github' && current_user.github_profile_url.blank?
      link_github_profile
    elsif request.env['omniauth.params']['youtube']
      link_to_youtube
    end
  end

end
