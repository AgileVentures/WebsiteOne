FactoryBot.define do
  factory :user, aliases: [:whodunnit] do
    trait(:with_karma) {  karma { Karma.new } }
    trait(:without_karma) {  karma { nil } }

    transient do
      gplus 'youtube_id_1'
    end

    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password '12345678'
    password_confirmation { password }
    display_profile true
    slug { "#{first_name} #{last_name}".parameterize }
    bio { Faker::Lorem.sentence }
    skill_list { Faker::Lorem.words(4) }

    after(:create) do |user, evaluator|
      create(:authentication, provider: 'gplus', uid: evaluator.gplus, user_id: user.id)
    end
  end

end
