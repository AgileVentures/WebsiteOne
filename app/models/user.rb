class User < ActiveRecord::Base
  include Filterable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  geocoded_by :last_sign_in_ip do |user, results|
    if geo = results.first
      user.latitude = geo.data['latitude']
      user.longitude = geo.data['longitude']
      user.city = geo.data['city']
      user.region = geo.data['region_name']
      user.country_name = geo.data['country_name']
      user.country_code = geo.data['country_code']
    end
  end

  acts_as_taggable_on :skills, :titles
  acts_as_voter
  acts_as_follower

  extend FriendlyId
  friendly_id :display_name, use: :slugged

  before_save :generate_timezone_offset

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
  scope :mail_receiver, -> { where(receive_mailings: true) }
  scope :project_filter, -> (project_id) {
    joins(:follows)
    .where(
      follows: {
        blocked: false,
        followable_id: project_id,
        followable_type: 'Project',
        follower_type: 'User'
      }
    )
  }
  scope :timezone_filter, -> (offset) {
    where("users.timezone_offset BETWEEN ? AND ?", offset[0], offset[1])
  }
  scope :allow_to_display, -> { where(display_profile: true) }
  scope :by_create, -> { order(:created_at) }
  scope :online, -> (argument) { where("users.updated_at > ?", 10.minutes.ago) }

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

  def self.find_by_github_username(username)
    github_url = "https://github.com/#{username}"
    find_by(github_profile_url: github_url)
  end

  def online?
    updated_at > 10.minutes.ago
  end

  def self.map_data
    users = User.group(:country_code).count
    clean = proc{ |k,v| !k.nil? ? Hash === v ? v.delete_if(&clean) : false : true }
    users.delete_if(&clean)
    users.to_json
  end

  def incomplete?
    bio.blank? || skills.blank? || first_name.blank? || last_name.blank?
  end

  private

  def send_slack_invite
    SlackInviteJob.new.async.perform(email)
  end

  def generate_timezone_offset
    if self.latitude && self.longitude
      self.timezone_offset = ActiveSupport::TimeZone.new(NearestTimeZone.to(self.latitude, self.longitude)).utc_offset
    end
  end
end
