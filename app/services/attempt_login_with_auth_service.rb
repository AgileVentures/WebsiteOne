class AttemptLoginWithAuthService
  attr_reader :current_user, :authentication

  def initialize(current_user, authentication) 
    @current_user = current_user 
    @authentication = authentication
  end

  def call(path, success:raise, failure:raise)
    if is_current_user_same_as_auth_user?
      failure.call(path)
    else
      success.call(authentication)
    end
  end

  private 

  def is_current_user_same_as_auth_user?
    authentication.user != current_user
  end


end
