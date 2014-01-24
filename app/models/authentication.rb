class Authentication < ActiveRecord::Base
  belongs_to :user
  validates :user_id, :provider, :uid, presence: true
end
