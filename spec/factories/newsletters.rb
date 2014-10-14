FactoryGirl.define do
  factory :newsletter do
    subject { Faker::Lorem.word }
    title { Faker::Lorem.sentence}
    body { Faker::Lorem.paragraph }
    do_send { false }
  end
end
