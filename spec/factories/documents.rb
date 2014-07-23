# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :document do
    sequence(:title) {|n| "Title #{n}"}
    sequence(:body) {|n| "MyText #{n}"}
    versions { [FactoryGirl.build(:version)] }
    project
  end
end

