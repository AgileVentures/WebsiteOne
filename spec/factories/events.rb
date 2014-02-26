FactoryGirl.define do
  factory :event do
    sequence(:name) { |n| "Event #{n}" }
    description 'Scumie scrum'
    is_all_day false
    from_date 'Mon, 17 Jun 2013'
    from_time '2000-01-01 09:00:00 UTC'
    to_date 'Mon, 17 Jun 2013'
    to_time '2000-01-01 09:14:00 UTC'
    repeats 'never'
    time_zone 'Eastern Time (US & Canada)'
  end
  factory :invalid_event do
    name nil
  end

end
