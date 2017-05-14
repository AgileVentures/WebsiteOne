FactoryGirl.define do
  factory :progress_task do
    title  { Faker::Lorem.words(1) }
    description { Faker::Lorem.words(4) }
  end
end