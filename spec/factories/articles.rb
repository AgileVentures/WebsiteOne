# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :article do
    sequence(:title) { |n| "Title #{n}" }
    content { Faker::Lorem.paragraph(sentence_count: 1) }
    tag_list { ['Ruby'] }
    slug { title.parameterize }
    user
  end
end
