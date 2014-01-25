module ApplicationHelper
  def gravatar_for(email, options = { size: 80 })
    hash = Digest::MD5::hexdigest(email.strip.downcase)
    "http://www.gravatar.com/avatar/#{hash}?s=#{options[:size]}&d=mm"
  end
  
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def current_projects
    Project.all
  end

  def social_button(provider)
    provider = provider.downcase
    display_name = {
        'github' => 'GitHub',
        'gplus'  => 'Google+'
    }
    fa_icon = {
        'github' => 'github-alt',
        'gplus'  => 'google-plus'
    }
    raw %Q{<a class="btn btn-lg btn-block btn-social btn-#{provider}" href="/auth/#{provider}"><i class="fa fa-#{fa_icon[provider]}"></i> Connect with #{display_name[provider]}</a>}
  end
end
