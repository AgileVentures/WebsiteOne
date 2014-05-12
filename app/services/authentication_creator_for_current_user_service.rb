class AuthenticationCreatorForCurrentUserService 

  def initialize(current_user, path, provider, uid) 
    @current_user = current_user
    @path = path
    @omniauth_provider = provider
    @omniauth_uid = uid
  end

  def call(success:raise, failure:raise)
    if current_user.create_new_authentication(omniauth_provider, omniauth_uid)
      success.call(path)
   else
      failure.call(path)
    end
  end

  private 
  attr_reader :current_user, :omniauth_provider, :omniauth_uid, :path

end
