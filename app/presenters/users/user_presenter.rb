# frozen_string_literal: true

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
    user.following_projects_count.positive?
  end

  def contributed?
    contributions.count.positive?
  end

  def contributions
    user.commit_counts.select do |commit_count|
      commit_count.user.following? commit_count.project
    end
  end

  def country
    user.country_name
  end
  alias_method :country?, :country

  def title_list
    content_tag(:span, user.titles.map(&:name).join(', '), class: 'member-title')
  end

  def has_title?
    user.titles.size.positive?
  end

  def gravatar_image(options = {})
    gravatar_url = if options[:default]
                     'https://www.gravatar.com/avatar/1&d=retro&f=y'
                   else
                     user.gravatar_url(options)
                   end

    image_tag(gravatar_url, width: options[:size], id: options[:id],
                            height: options[:size], alt: display_name, class: options[:class], style: options[:style])
  end

  def email_link(text = nil)
    link_to(user.email, (text or user.email))
  end

  def github_username
    user.github_profile_url&.split('/')&.last
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
    user.status.size.positive?
  end

  def blank_fields
    %w(first_name last_name skills bio)
      .select { |field| user.send(field).blank? }
      .map(&:humanize).to_sentence
  end

  def user_same_as?(other_user)
    user == other_user
  end

  def display_hire_me?(current_user = nil)
    user.display_hire_me && !user_same_as?(current_user)
  end
end
