require_relative '../base_presenter'

class UserPresenter < BasePresenter

  alias_method :user, :object

  def display_name
    user.display_name
  end

  def has_skills?
    !user.skill_list.blank?
  end

  def joined_projects?
    !user.projects_joined.blank?
  end

  def title_list
    content_tag(:span, user.title_list.join(', '), class: 'member-title')
  end

  def has_title?
    user.title_list.count > 0
  end

  def timezone
    NearestTimeZone.to(user.latitude, user.longitude)
  end

  def gravatar_src(options={})
    options = { size: 80 }.merge(options)
    hash = Digest::MD5::hexdigest(user.email.strip.downcase)
    "https://www.gravatar.com/avatar/#{hash}?s=#{options[:size]}&d=retro"
  end

  def gravatar_image(options={})
    options = { size: 80 }.merge(options)
    image_tag(gravatar_src(options), width: options[:size], id: options[:id],
              height: options[:size], alt: display_name, class: options[:class])
  end

  def email_link(text=nil)
    link_to(user.email, (text or user.email))
  end

  def github_username
    user.github_profile_url.split('/').last if user.github_profile_url
  end

  def github_link
    link_to(github_username, user.github_profile_url)
  end
end
