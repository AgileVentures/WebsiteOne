FactoryGirl.define do
  factory :project do
    sequence(:title) {|n| "Title #{n}"}
    description "Description 1"
    status "Status 1"
  end
end