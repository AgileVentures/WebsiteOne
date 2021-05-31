# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :static_page do
    sequence(:title) { |n| "Page #{n}" }
    sequence(:body) { |n| "My Static Page #{n}" }
  end
end
