require 'spec_helper'

describe Event do
  it 'is scheduled for one occasion' do
    event =  Event.create!( name: 'one time event',
                            category: 'Scrum',
                            description: '',
                            is_all_day: false,
                            from_date: 'Mon, 17 Jun 2013',
                            from_time: '2000-01-01 09:00:00 UTC',
                            to_date: 'Mon, 17 Jun 2013',
                            to_time: '2000-01-01 17:00:00 UTC',
                            repeats: 'never',
                            repeats_every_n_weeks: nil,
                            repeat_ends: 'never',
                            repeat_ends_on: 'Mon, 17 Jun 2013',
                            time_zone: 'Eastern Time (US & Canada)')
    expect(event.schedule.first(5)).to eq(['Mon, 17 Jun 2013 09:00:00 EDT -04:00'])
    expect(event.schedule.first(5)).not_to eq(['Sun, 16 Jun 2013 09:00:00 EDT -04:00'])
    expect(event.schedule.first(5)).not_to eq(['Tue, 18 Jun 2013 00:00:00 EDT -04:00'])
  end

  it 'is scheduled for every weekend' do
    event =  Event.create!( name: 'every weekend event',
                            category: 'Scrum',
                            description: '',
                            is_all_day: false,
                            from_date: 'Mon, 17 Jun 2013',
                            from_time: '2000-01-01 09:00:00 UTC',
                            to_date: 'Mon, 17 Jun 2013',
                            to_time: '2000-01-01 17:00:00 UTC',
                            repeats: 'weekly',
                            repeats_every_n_weeks: 1,
                            repeats_weekly_each_days_of_the_week_mask: 65,
                            repeat_ends: 'never',
                            repeat_ends_on: 'Tue, 25 Jun 2013',
                            time_zone: 'Eastern Time (US & Canada)')
    expect(event.schedule.first(5)).to eq(['Sat, 22 Jun 2013 09:00:00 EDT -04:00', 'Sun, 23 Jun 2013 09:00:00 EDT -04:00', 'Sat, 29 Jun 2013 09:00:00 EDT -04:00', 'Sun, 30 Jun 2013 09:00:00 EDT -04:00', 'Sat, 06 Jul 2013 09:00:00 EDT -04:00'])
    expect(event.schedule.first(7)).not_to eq(['Mon, 17 Jun 2013 09:00:00 EDT -04:00i', 'Tue, 18 Jun 2013 09:00:00 EDT -04:00', 'Wed, 19 Jun 2013 09:00:00 EDT -04:00', 'Thu, 20 Jun 2013 09:00:00 EDT -04:00', 'Fri, 21 Jun 2013 09:00:00 EDT -04:00', 'Mon, 24 Jun 2013 09:00:00 EDT -04:00', 'Tue, 25 Jun 2013 09:00:00 EDT -04:00'])
  end

  it 'is scheduled for every Sunday' do
    event =  Event.create!( name: 'every Sunday event',
                            category: 'Scrum',
                            description: '',
                            is_all_day: false,
                            from_date: 'Mon, 17 Jun 2013',
                            from_time: '2000-01-01 09:00:00 UTC',
                            to_date: 'Mon, 17 Jun 2013',
                            to_time: '2000-01-01 17:00:00 UTC',
                            repeats: 'weekly',
                            repeats_every_n_weeks: 1,
                            repeats_weekly_each_days_of_the_week_mask: 1,
                            repeat_ends: 'never',
                            repeat_ends_on: 'Mon, 17 Jun 2013',
                            time_zone: 'Eastern Time (US & Canada)')
    expect(event.schedule.first(5)).to eq(['Sun, 23 Jun 2013 09:00:00 EDT -04:00', 'Sun, 30 Jun 2013 09:00:00 EDT -04:00', 'Sun, 07 Jul 2013 09:00:00 EDT -04:00', 'Sun, 14 Jul 2013 09:00:00 EDT -04:00', 'Sun, 21 Jul 2013 09:00:00 EDT -04:00'])
    expect(event.schedule.first(5)).not_to eq(['Mon, 17 Jun 2013 09:00:00 EDT -04:00', 'Mon, 24 Jun 2013 09:00:00 EDT -04:00', 'Mon, 01 Jul 2013 09:00:00 EDT -04:00', 'Mon, 08 Jul 2013 09:00:00 EDT -04:00', 'Mon, 15 Jul 2013 09:00:00 EDT -04:00'])
  end

  it 'is scheduled for every Monday' do
    event =  Event.create!( name: 'every Monday event',
                            category: 'Scrum',
                            description: '',
                            is_all_day: false,
                            from_date: 'Mon, 17 Jun 2013',
                            from_time: '2000-01-01 09:00:00 UTC',
                            to_date: 'Mon, 17 Jun 2013',
                            to_time: '2000-01-01 17:00:00 UTC',
                            repeats: 'weekly',
                            repeats_every_n_weeks: 1,
                            repeats_weekly_each_days_of_the_week_mask: 2,
                            repeat_ends: 'never',
                            repeat_ends_on: 'Mon, 17 Jun 2013',
                            time_zone: 'Eastern Time (US & Canada)')
    expect(event.schedule.first(5)).to eq(['Mon, 17 Jun 2013 09:00:00 EDT -04:00', 'Mon, 24 Jun 2013 09:00:00 EDT -04:00', 'Mon, 01 Jul 2013 09:00:00 EDT -04:00', 'Mon, 08 Jul 2013 09:00:00 EDT -04:00', 'Mon, 15 Jul 2013 09:00:00 EDT -04:00'])
    expect(event.schedule.first(5)).not_to eq(['Sun, 23 Jun 2013 09:00:00 EDT -04:00', 'Sun, 30 Jun 2013 09:00:00 EDT -04:00', 'Sun, 07 Jul 2013 09:00:00 EDT -04:00', 'Sun, 14 Jul 2013 09:00:00 EDT -04:00', 'Sun, 21 Jul 2013 09:00:00 EDT -04:00'])
  end

end
