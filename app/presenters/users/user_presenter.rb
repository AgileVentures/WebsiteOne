require_relative '../base_presenter'

class UserPresenter < BasePresenter

  def display_name
    object.display_name
  end

  def title_list
    "<span class=\"member-title\">#{object.title_list.join(', ')}</span>".html_safe
  end

  def gravatar_src(options={size: 80})
    hash = Digest::MD5::hexdigest(object.email.strip.downcase)
    "https://www.gravatar.com/avatar/#{hash}?s=#{options[:size]}&d=retro"
  end

  def email_link(text=nil)
    link_to(object.email, (text or object.email))
  end

  def github_username
    object.github_profile_url.split('/').last if object.github_profile_url
  end

  def github_link
    link_to(github_username, object.github_profile_url)
  end
end
