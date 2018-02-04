# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :document do
    sequence(:title) {|n| "Title #{n}"}
    sequence(:body) {|n| "MyText #{n}"}
    slug { title.parameterize }
    versions { [FactoryBot.build(:version)] }
    project
    user
  end
end

