# frozen_string_literal: true

class Subscription < ApplicationRecord
  belongs_to :user, -> { with_deleted }
  belongs_to :plan

  validates :started_at, presence: true
  has_one :payment_source, class_name: 'PaymentSource::PaymentSource'
  belongs_to :sponsor, -> { with_deleted }, class_name: 'User', foreign_key: :sponsor_id, optional: true
  delegate :identifier, to: :payment_source
end
