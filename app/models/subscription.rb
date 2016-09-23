class Subscription < ActiveRecord::Base
  belongs_to :user
end

class Premium < Subscription
end

class PremiumPlus < Subscription
end