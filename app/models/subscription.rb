class Subscription < ActiveRecord::Base
  belongs_to :user, -> { with_deleted }
  belongs_to :plan

  validates_presence_of :started_at
  has_one :payment_source, class_name: PaymentSource::PaymentSource
  belongs_to :sponsor, -> { with_deleted }, class_name: "User", foreign_key: :sponsor_id
  delegate :identifier, to: :payment_source
end
