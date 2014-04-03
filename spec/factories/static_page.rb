# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :static_page do
    sequence(:title) {|n| "Page #{n}"}
    sequence(:body) {|n| "My Static Page #{n}"}
  end
end

