module CreateAuthentication
  extend self

  def for(user, omniauth, success:raise, failure:raise)
    user.authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
    # user profile updated with new omniauth info
    user.update(email: omniauth['info']['email']) unless user.email?
    if user.save
      success.call(user)
    else
      failure.call
    end
  end
end
