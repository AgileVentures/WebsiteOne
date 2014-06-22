require 'url_validator'

class Project < ActiveRecord::Base
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

  def self.all_tags
    Project.tag_counts_on('tags').map{|tag| tag.name}
  end

  def youtube_tags
    tag_list
      .push(title)
      .map(&:downcase)
      .uniq
  end

  def members
    followers.reject { |member| !member.display_profile }
  end

  def members_tags
    members.map(&:youtube_user_name)
      .compact
      .map(&:downcase)
      .uniq
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
