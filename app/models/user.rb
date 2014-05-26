class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  #validates :first_name, :last_name, presence: true
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

  #after_create Mailer.send_welcome_mail()
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  validates :email, uniqueness: true
  after_validation :geocode, if: ->(obj){ obj.last_sign_in_ip }
  after_validation ->() { KarmaCalculator.new(self).perform }

  has_many :authentications, dependent: :destroy
  has_many :projects
  has_many :documents
  has_many :articles



  acts_as_follower

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

  def display_name
    name = [ self.first_name, self.last_name ].join(' ').squish
    if (name == '' || name == nil) && (self.email == '' || self.email == nil)
      'Anonymous'
    elsif name =~ /^\s*$/
      self.email_first_part
    else
      name
    end
  end

  def should_generate_new_friendly_id?
    self.slug.nil? or ((self.first_name_changed? or self.last_name_changed?) and not self.slug_changed?)
  end

  def email_first_part
    self.email.gsub(/@.*$/, '')
  end

  def slug_candidates
    [ :display_name, :email_first_part ]
  end
end
