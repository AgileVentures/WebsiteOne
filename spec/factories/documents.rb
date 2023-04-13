# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :document do
    sequence(:title) { |n| "Title #{n}" }
    sequence(:body) { |n| "MyText #{n}" }
    sequence(:content) { |n| "MyContent #{n}" }
    slug { title.parameterize }
    versions { [FactoryBot.build(:version)] }
    project
    user
  end
end
