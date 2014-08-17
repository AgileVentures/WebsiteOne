class UserAuthentication < ActiveRecord::Base
  belongs_to :user
  belongs_to :authentication_provider

  validates :user, presence: true
  validates :authentication_provider, presence: true

  serialize :params

end
