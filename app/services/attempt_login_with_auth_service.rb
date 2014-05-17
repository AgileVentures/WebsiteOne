class AttemptLoginWithAuthService
  def initialize(authentication, path, current_user) 
    @authentication = authentication
    @path = path 
    @current_user = current_user
  end

  def call(success:raise, failure:raise)
    if authentication.present?
      if current_user.present? and auth_user_is_not_current_user?
        failure.call(path)
      else
        success.call(authentication)  
      end
    end
  end

  private 
  attr_reader :authentication, :path, :current_user

  def auth_user_is_not_current_user?
    authentication.user != current_user 
  end
end
