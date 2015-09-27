# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :status do
    status { Status::OPTIONS[rand(Status::OPTIONS.length)] }
    user
  end
end
