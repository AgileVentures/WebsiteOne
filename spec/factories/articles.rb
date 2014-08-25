# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :article do
    sequence(:title) {|n| "Title #{n}"}
    content Faker::Lorem.paragraph(1)
    tag_list [ 'Ruby' ]
    sequence(:slug) {|n| "friendly_id_#{n}" }
    user
  end
end
