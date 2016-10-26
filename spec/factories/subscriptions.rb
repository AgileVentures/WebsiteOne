FactoryGirl.define do
  factory :subscription do
    type 'Premium'
    started_at Time.now
  end
end