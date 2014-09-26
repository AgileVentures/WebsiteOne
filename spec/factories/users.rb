FactoryGirl.define do
  factory :user, aliases: [:whodunnit] do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password 'changeme'
    password_confirmation 'changeme'
    display_profile true
    slug { "#{first_name} #{last_name}".parameterize }
  end
end
