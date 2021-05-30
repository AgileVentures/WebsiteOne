class User < ApplicationRecord
  acts_as_paranoid

  include Filterable

  extend Forwardable

  def_delegator :karma, :hangouts_attended_with_more_than_one_participant=
  def_delegator :karma, :hangouts_attended_with_more_than_one_participant

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

  PREMIUM_MOB_PLAN_AMOUNT = 500 # downgrading this to associate membership level

  acts_as_taggable_on :skills, :titles
  acts_as_voter
  acts_as_follower

  extend FriendlyId
  friendly_id :display_name, use: :slugged

  after_validation :geocode, if: ->(obj) { obj.last_sign_in_ip_changed? }
  # after_validation -> { KarmaCalculator.new(self).perform }
  after_create :send_slack_invite, if: -> { Features.slack.invites.enabled }

  has_many :authentications, dependent: :destroy
  has_many :projects
  has_many :documents
  has_many :articles
  has_many :event_instances
  has_many :commit_counts
  has_many :status

  has_many :subscriptions, autosave: true

  def stripe_customer_id # ultimately replacing the field stripe_customer
    subscription = current_subscription
    return nil unless subscription
    subscription.identifier
  end

  has_one :karma

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
  scope :allow_to_display, -> { where(display_profile: true) }
  scope :by_create, -> { order(:created_at) }
  scope :online, -> (_argument) { where("users.updated_at > ?", 10.minutes.ago) }
  scope :title, -> (title) { tagged_with(title) }

  self.per_page = 30

  def current_subscription
    now = DateTime.now
    current_subscriptions = subscriptions.select { |s| s.ended_at.nil? and s.started_at.to_i <= now.to_i }
    return nil if current_subscriptions.nil? or current_subscriptions.empty?
    current_subscriptions.first
  end

  def allowed_to_attend?
    current_subscription and current_subscription.plan.amount >= PREMIUM_MOB_PLAN_AMOUNT
  end

  def self.filter_if_title title
    return User.all if title.blank?
    User.tagged_with(title)
  end

  def membership_type
    subscription = current_subscription
    return "Basic" unless subscription
    subscription.plan.name
  end

  def apply_omniauth(omniauth)
    self.email = omniauth['info']['email'] if email.blank?
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid']) unless email.blank?
    @omniauth_provider = omniauth['provider']
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

  def profile_completeness
    awarded = 0
    awarded += 2 if skill_list.present?
    awarded += 2 if github_profile_url.present?
    awarded += 2 if youtube_user_name.present?
    awarded += 2 if bio.present?
    awarded += 1 if first_name.present?
    awarded += 1 if last_name.present?
    return awarded
  end

  def is_privileged?
    return false if Settings.privileged_users.blank?
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
    clean = proc { |k, v| !k.nil? ? Hash === v ? v.delete_if(&clean) : false : true }
    users.delete_if(&clean)
    users.to_json
  end

  def incomplete?
    bio.blank? || skills.blank? || first_name.blank? || last_name.blank?
  end

  def commit_count_total
    commit_counts.sum :commit_count
  end

  def number_hangouts_started_with_more_than_one_participant
    event_instances.count { |h| h.participants != nil && h.participants.to_unsafe_h.count > 1 }
  end

  def activity
    2 * [[(sign_in_count - 2), 0].max, 3].min
  end

  def membership_length
    1 * [user_age_in_months.to_i, 6].min
  end

  def karma_total
    return karma.total if karma
    0
  end

  private

  def user_age_in_months
    (DateTime.current - created_at.to_datetime).to_i / 30
  end

  def send_slack_invite
    SlackInviteJob.perform_async(email)
  end

  validate :email_absence

  def email_absence
    if email.blank? and not @omniauth_provider.nil?
      errors.delete(:password)
      errors.delete(:email)
      errors.add(:base, I18n.t('error_messages.public_email', provider: @omniauth_provider.capitalize))
    end
  end
end
