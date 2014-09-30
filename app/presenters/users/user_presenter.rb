require_relative '../base_presenter'

class UserPresenter < BasePresenter
  presents :user

  def display_name
    user.display_name
  end

  def has_skills?
    !user.skill_list.blank?
  end

  def joined_projects?
    user.following_projects_count > 0
  end

  def contributed?
    contributions.count > 0
  end

  def contributions
    user.commit_counts.select do |commit_count|
      commit_count.user.following? commit_count.project
    end
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

  def gravatar_image(options={})
    if options[:default]
      gravatar_url = "https://www.gravatar.com/avatar/1&d=retro&f=y"
    else
      gravatar_url = user.gravatar_url(options)
    end

    image_tag(gravatar_url, width: options[:size], id: options[:id],
              height: options[:size], alt: display_name, class: options[:class], style: options[:style])
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

  def profile_link
    user.is_a?(NullUser) ? '#' : url_helpers.user_path(user)
  end

  def status
    content_tag(:span, user.status.last[:status])
  end

  def status?
    user.status.count > 0
  end

end
