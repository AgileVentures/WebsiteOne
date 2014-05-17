require 'url_validator'

class Project < ActiveRecord::Base
  include YoutubeApi
  extend FriendlyId
  friendly_id :title, use: :slugged

  validates :title, :description, :status, presence: true
  validates_with UrlValidator
  validates :github_url, uri: true, :allow_blank => true
  acts_as_followable
  belongs_to :user
  has_many :documents

  acts_as_taggable # Alias for acts_as_taggable_on :tags

  def self.search(search, page)
    order('LOWER(title)')
      .where('title LIKE ?', "%#{search}%")
      .paginate(per_page: 5, page: page)
  end

  def members
    followers.reject { |member| !member.display_profile }
  end

  def videos
    members_tags = YoutubeApi.members_tags(members)
    return [] if members_tags.blank?
    project_tags = YoutubeApi.project_tags(self)

    request = YoutubeApi.build_request(:project, members_tags, project_tags)
    response = YoutubeApi.get_response(request)
    YoutubeApi.filter_response(response, project_tags, members_tags) if response
  end

  # Bryan: Used to generate paths, used only in testing.
  # Might want to switch to rake generated paths in the future
  def url_for_me(action)
    if action == 'show'
      "/projects/#{to_param}"
    else
      "/projects/#{to_param}/#{action}"
    end
  end
end

