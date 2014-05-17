class AuthenticationCreatorForNewUserService
  def initialize(current_user, omniauth, path)
    @omniauth = omniauth 
    @path = path
    @current_user = current_user
  end

  def create(success:raise, failure:raise)
    if current_user.create_new_authentication(omniauth_provider, omniauth_uid)
      success.call
    else 
      failure.call 
    end
  end

  private 
  def omniauth_provider 
    omniauth.fetch(:provider)
  end

  def omniauth_uid 
    omniauth.fetch(:uid)
  end

  attr_reader :omniauth, :path, :current_user
end
