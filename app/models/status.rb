class Status < ActiveRecord::Base
  belongs_to :user

  validates :status, :user_id, presence: true
end
