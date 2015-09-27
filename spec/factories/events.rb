FactoryGirl.define do
  factory :event do
    sequence(:name) { |n| "Event #{n}" }
    category 'Scrum'
    description ''
    start_datetime '2014-03-07 23:30:00 UTC'
    duration '1'
    repeats 'weekly'
    repeats_every_n_weeks '1'
    repeats_weekly_each_days_of_the_week_mask '64'
    repeat_ends_string 'on'
    repeat_ends_on '2015-03-31'
    time_zone 'UTC'
  end
  factory :invalid_event do
    name nil
  end
end
