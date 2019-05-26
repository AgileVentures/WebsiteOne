FactoryBot.define do
  factory :language do
    sequence(:name) { |n| "Ruby #{n}"}
  end
end
