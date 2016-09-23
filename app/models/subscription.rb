class Subscription < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :started_at
  has_one :payment_source
end

class Premium < Subscription
end

class PremiumPlus < Subscription
end