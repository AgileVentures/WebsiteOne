class AuthenticationCreatorService
  def initialize(listener, authentication, current_user)
    @listener = listener 
    @authentication = authentication
    @current_user = current_user
  end

  def create(omniauth, path)
    if authentication.present?

    elsif current_user
      listener.create_new_authentication_for_current_user(omniauth, path)

    else
      listener.create_new_user_with_authentication(omniauth)
    end

    if current_user && omniauth['provider']=='github' && current_user.github_profile_url.blank?
      listener.link_github_profile
    end
  end

  private 
  attr_reader :listener, :authentication, :current_user
end
