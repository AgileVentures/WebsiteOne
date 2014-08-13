FactoryGirl.define do
  factory :user, aliases: [:whodunnit] do
    ignore do
      gplus 'gplus_id'
    end

    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password '12345678'
    password_confirmation { password }
    display_profile true
    slug { "#{first_name} #{last_name}".parameterize }

    after(:create) do |user, evaluator|
      create(:authentication, provider: 'gplus', uid: evaluator.gplus, user_id: user.id )
    end
  end
end
