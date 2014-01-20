FactoryGirl.define do
  factory :user do
    first_name 'Test'
    last_name 'User'
    email 'example@example.com'
    password 'changemelater'
    password_confirmation 'changemelater'
    # required if the Devise Confirmable module is used
    # confirmed_at Time.now
  end
end
