module AttemptLoginWithAuthService
  extend self 

  def call(current_user, path, authentication, success:raise, failure:raise)
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
