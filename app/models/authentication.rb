class Authentication < ActiveRecord::Base
  belongs_to :user
  # Bryan: validation of user presence is done at the database level, model level will cause problems
  validates :provider, :uid, presence: true
end
