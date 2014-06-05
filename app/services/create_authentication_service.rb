module CreateAuthentication
  extend self
  def for(user, omniauth, provider_is_youtube, success:raise, failure:raise)
    user.authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
    # user profile updated with new omniauth info
    user.update_attributes(email: omniauth['info']['email']) unless user.email?
    if user.save
      success.call
    else
      failure.call
    end
  end
end

module GithubPolicy
  extend self

  def create(omniauth, user)
    url = ''
    begin
      url = omniauth['info']['urls']['GitHub']
    rescue NoMethodError
      return
    end

    #TODO: Think about possible failure scenarios
    user.update(github_profile_url: url)
  end
end

module GplusPolicy
  extend self

  def create(omniauth, user)
    user.update_youtube_id_if(omniauth['credentials']['token'])
  end
end

