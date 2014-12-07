class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  geocoded_by :last_sign_in_ip do |user, res|
    if geo = res.first
      user.latitude = geo.data['latitude']
      user.longitude = geo.data['longitude']
      user.city = geo.data['city']
      user.region = geo.data['region_name']
      user.country = geo.data['country_name']
    end
  end

  acts_as_taggable_on :skills, :titles
  acts_as_voter
  acts_as_follower

  extend FriendlyId
  friendly_id :display_name, use: :slugged

  after_validation :geocode, if: ->(obj){ obj.last_sign_in_ip_changed? }
  after_validation -> { KarmaCalculator.new(self).perform }
  after_create :send_slack_invite, if: -> { Features.slack.invites.enabled }

  has_many :authentications, dependent: :destroy
  has_many :projects
  has_many :documents
  has_many :articles
  has_many :event_instances
  has_many :commit_counts
  has_many :status

  accepts_nested_attributes_for :status
  scope     :mail_receiver, -> { where(receive_mailings: true) }

  self.per_page = 30

  def apply_omniauth(omniauth)
    self.email = omniauth['info']['email'] if email.blank?
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end

  def password_required?
    (authentications.empty? || !password.blank?) && super
  end

  def has_auth(provider)
    !authentications.where(provider: provider).empty?
  end

  def followed_project_tags
    following_projects
      .flat_map(&:youtube_tags)
      .push('scrum')
  end

  def display_name
    full_name || email_designator || 'Anonymous'
  end

  def full_name
    full_name = "#{first_name} #{last_name}".squish
    full_name unless full_name.blank?
  end

  def email_designator
    return if email.blank?
    email.split('@').first
  end

  def should_generate_new_friendly_id?
    self.slug.nil? or ((self.first_name_changed? or self.last_name_changed?) and not self.slug_changed?)
  end

  def gravatar_url(options={})
    hash = Digest::MD5::hexdigest(email.strip.downcase)
    if options[:size]
      "https://www.gravatar.com/avatar/#{hash}?s=#{options[:size]}&d=retro"
    else
      "https://www.gravatar.com/avatar/#{hash}?d=retro"
    end
  end

  def is_privileged?
    Settings.privileged_users.split(',').include?(email)
  end

  def self.search(params)
    # TODO this code is not tested
    # NOTE maybe we create a filters hash ie., { filters: { project_filter: 6, another_filter: "foo"}
    # to make it easier to detect if a given search has filtering parameters set?
    if params['project_filter']
      Project.find(params['project_filter']).followers
    else
      # NOTE maybe we return a paginated list when no filtering criteria?
      where(display_profile: true)
        .order(:created_at)
    end
  end

  def self.find_by_github_username(username)
    github_url = "https://github.com/#{username}"
    find_by(github_profile_url: github_url)
  end

  def online?
    updated_at > 10.minutes.ago
  end

  private

  def send_slack_invite
    SlackInviteJob.new.async.perform(email)
  end
end
