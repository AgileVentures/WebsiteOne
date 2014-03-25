FactoryGirl.define do
  factory :event do
    sequence(:name) { |n| "Event #{n}" }
    category 'Scrum'
    description ''
    event_date '2014-03-07'
    start_time '23:30:00'
    end_time '23:30:00'
    repeats 'weekly'
    repeats_every_n_weeks '1'
    repeats_weekly_each_days_of_the_week_mask '64'
    repeat_ends 'on'
    repeat_ends_on '2014-03-31'
    time_zone 'London'
  end
  factory :invalid_event do
    name nil
  end
end
