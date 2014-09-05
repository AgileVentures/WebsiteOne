# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :article do
    sequence(:title) {|n| "Title #{n}"}
    content Faker::Lorem.paragraph(1)
    tag_list [ 'Ruby' ]
    slug { title.parameterize }
    user
  end
end
