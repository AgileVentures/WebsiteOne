class AuthenticationCreatorService
  def self.create 
    if authentication.present?
      attempt_login_with_auth(authentication, @path)

    elsif current_user
      create_new_authentication_for_current_user(omniauth, @path)

    else
      create_new_user_with_authentication(omniauth)
    end

    if current_user && omniauth['provider']=='github' && current_user.github_profile_url.blank?
      link_github_profile
    end
  end
end
