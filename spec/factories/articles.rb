# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :article do
    sequence(:title) {|n| "Title #{n}"}
    content Faker::Lorem.paragraph(1)
    tag_list [ 'Ruby' ]
    slug 'friendly_id'
    user
  end
end
