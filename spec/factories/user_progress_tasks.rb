FactoryGirl.define do
  factory :user_progress_task do
    user_id { 1 }
    sequence(:progress_task_id) { |n| }
    title  { Faker::Lorem.words(1) }
    description { Faker::Lorem.words(4) }
  end
end