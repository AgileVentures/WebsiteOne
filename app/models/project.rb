class Project < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]

  validates :title, :description, :status, presence: true
  validates_with PivotalTrackerUrlValidator
  validates :github_url, uri: true, :allow_blank => true
  validates_with ImageUrlValidator
  validates :image_url, uri: true, :allow_blank => true

  belongs_to :user
  include UserNullable
  include PublicActivity::Common
  has_many :documents
  has_many :event_instances
  has_many :commit_counts
  has_many :source_repositories
  accepts_nested_attributes_for :source_repositories, reject_if: :all_blank, allow_destroy: true

  acts_as_followable
  acts_as_taggable # Alias for acts_as_taggable_on :tags

  scope :with_github_url, ->{ includes(:source_repositories).where.not(source_repositories: { id: nil }) }

  def self.search(search, page)
    order('LOWER(title)')
      .where('title LIKE ?', "%#{search}%")
      .paginate(per_page: 5, page: page)
  end

  def gpa
    CodeClimateBadges.new("github/#{github_repo}").gpa
  end

  def github_url
    source_repositories.first.try(:url)
  end

  def youtube_tags
    tag_list
      .clone
      .push(title)
      .map(&:downcase)
      .uniq
  end

  def members
    followers.select(&:display_profile)
  end

  def members_tags
    members.map(&:youtube_user_name)
      .compact
      .map(&:downcase)
      .uniq
  end

  def github_repo
    if github_url.blank?
      ''
    else
      /github.com\/(.+)/.match(github_url)[1]
    end
  end

  def github_repo_name
    github_url ? /github.com\/(\w+)\/\w+/.match(github_url)[1] : ''
  end

  def github_repo_user_name
    github_url ? /github.com\/\w+\/([\w\-]+)/.match(github_url)[1] : ''
  end

  def contribution_url
    "https://github.com/#{github_repo}/graphs/contributors"
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

  def jitsi_room_link
    "https://meet.jit.si/AV_#{title.tr(' ', '_').gsub(/[^0-9a-zA-Z_]/i, '')}"
  end

  private

  def should_generate_new_friendly_id?
    # Used by the friendly_id gem
    changes.include?(:title)
  end
end
