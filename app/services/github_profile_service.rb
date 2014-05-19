module GithubProfileService
  extend ProfileService
  extend self

  def call(current_user, omniauth, failure:raise) 
    unless current_user.update_github_url(url(omniauth))
      failure.call(current_user, provider(omniauth))
    end
  end

  private 
  def url(omniauth)
    omniauth.fetch('info', {}).fetch('urls',{}).fetch('GitHub', nil)
  end

  def provider(omniauth)
    omniauth.fetch('provider')
  end

end
