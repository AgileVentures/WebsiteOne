# frozen_string_literal: true

FactoryBot.define do
  factory :plan do
    name { '' }
    free_trial_length_days { '' }
    third_party_identifier { 'MyString' }
    amount { 0 }
  end
end
