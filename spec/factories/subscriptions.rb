# frozen_string_literal: true

FactoryBot.define do
  factory :subscription do
    type { 'Premium' }
    started_at { Time.now }
    user
  end
end
