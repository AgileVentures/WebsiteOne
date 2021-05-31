# frozen_string_literal: true

FactoryBot.define do
  factory :karma do
    total { 1 }
    hangouts_attended_with_more_than_one_participant { 1 }
  end
end
