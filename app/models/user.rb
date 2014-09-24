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

  has_many :authentications, dependent: :destroy
  has_many :projects
  has_many :documents
  has_many :articles
  has_many :hangouts
  has_many :commit_counts 

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

  def self.search(params)
    where(display_profile: true)
      .order(:created_at)
  end

  def self.find_by_github_username(username)
    github_url = "https://github.com/#{username}"
    find_by(github_profile_url: github_url)
  end
end
