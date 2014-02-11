class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  #validates :first_name, :last_name, presence: true

  # TODO Bryan: implement slug for users
  #extend FriendlyId
  #friendly_id :display_name, :slugged

  validates :email, uniqueness: true
  has_many :authentications, dependent: :destroy
  has_many :projects
  has_many :documents

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
    if name.match /^\s+$/
      self.email
    else
      name
    end
  end
end
