class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :plan

  validates_presence_of :started_at
  has_one :payment_source, class_name: PaymentSource::PaymentSource
  belongs_to :sponsor, class_name: "User", foreign_key: :sponsor_id
  delegate :identifier, to: :payment_source
end
