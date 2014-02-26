require 'spec_helper'

describe Event do
  it 'is scheduled for one occasion' do
    event =  Event.create!( name: 'one time event',
                            description: '',
                            is_all_day: false,
                            from_date: 'Mon, 17 Jun 2013',
                            from_time: '2000-01-01 09:00:00 UTC',
                            to_date: 'Mon, 17 Jun 2013',
                            to_time: '2000-01-01 17:00:00 UTC',
                            repeats: 'never',
                            repeats_every_n_days: nil,
                            repeats_every_n_weeks: nil,
                            repeats_every_n_months: nil,
                            repeats_monthly: 'each',
                            repeats_every_n_years: nil,
                            repeats_yearly_on: false,
                            repeat_ends: 'never',
                            repeat_ends_on: 'Mon, 17 Jun 2013',
                            time_zone: 'Eastern Time (US & Canada)')
    expect(event.schedule.first(5)).to eq(['Mon, 17 Jun 2013 09:00:00 EDT -04:00'])
    expect(event.schedule.first(5)).not_to eq(['Sun, 16 Jun 2013 09:00:00 EDT -04:00'])
    expect(event.schedule.first(5)).not_to eq(['Tue, 18 Jun 2013 00:00:00 EDT -04:00'])
  end

  it 'is scheduled for one occasion as all day event' do
    event =  Event.create!( name: 'one time event all day',
                            description: '',
                            is_all_day: true,
                            from_date: 'Mon, 17 Jun 2013',
                            from_time: '2000-01-01 00:00:00 UTC',
                            to_date: 'Mon, 17 Jun 2013',
                            to_time: '2000-01-01 00:00:00 UTC',
                            repeats: 'never',
                            repeats_every_n_days: nil,
                            repeats_every_n_weeks: nil,
                            repeats_every_n_months: nil,
                            repeats_monthly: 'each',
                            repeats_every_n_years: nil,
                            repeats_yearly_on: false,
                            repeat_ends: 'never',
                            repeat_ends_on: 'Mon, 17 Jun 2013',
                            time_zone: 'Eastern Time (US & Canada)')
    expect(event.schedule.first(5)).to eq(['Mon, 17 Jun 2013 00:00:00 EDT -04:00'])
    expect(event.schedule.first(5)).not_to eq(['Sun, 16 Jun 2013 00:00:00 EDT -04:00'])
    expect(event.schedule.first(5)).not_to eq(['Tue, 18 Jun 2013 00:00:00 EDT -04:00'])
  end

  it 'is scheduled for every 4 days' do
    event =  Event.create!( name: 'every 4 day event',
                            description: '',
                            is_all_day: false,
                            from_date: 'Mon, 17 Jun 2013',
                            from_time: '2000-01-01 09:00:00 UTC',
                            to_date: 'Mon, 17 Jun 2013',
                            to_time: '2000-01-01 17:00:00 UTC',
                            repeats: 'daily',
                            repeats_every_n_days: 4,
                            repeats_every_n_weeks: nil,
                            repeats_every_n_months: nil,
                            repeats_monthly: 'each',
                            repeats_every_n_years: nil,
                            repeats_yearly_on: false,
                            repeat_ends: 'never',
                            repeat_ends_on: 'Mon, 17 Jun 2013',
                            time_zone: 'Eastern Time (US & Canada)')
    expect(event.schedule.first(5)).to eq(['Mon, 17 Jun 2013 09:00:00 EDT -04:00', 'Fri, 21 Jun 2013 09:00:00 EDT -04:00', 'Tue, 25 Jun 2013 09:00:00 EDT -04:00', 'Sat, 29 Jun 2013 09:00:00 EDT -04:00', 'Wed, 03 Jul 2013 09:00:00 EDT -04:00'])
    expect(event.schedule.first(5)).not_to eq(['Sun, 16 Jun 2013 09:00:00 EDT -04:00', 'Thu, 20 Jun 2013 09:00:00 EDT -04:00', 'Mon, 24 Jun 2013 09:00:00 EDT -04:00', 'Fri, 28 Jun 2013 09:00:00 EDT -04:00', 'Tue, 02 Jul 2013 09:00:00 EDT -04:00'])
    expect(event.schedule.first(5)).not_to eq(['Tue, 18 Jun 2013 09:00:00 EDT -04:00', 'Sat, 22 Jun 2013 09:00:00 EDT -04:00', 'Wed, 26 Jun 2013 09:00:00 EDT -04:00', 'Sun, 30 Jun 2013 09:00:00 EDT -04:00', 'Thu, 04 Jul 2013 09:00:00 EDT -04:00'])
  end

  it 'is scheduled for every weekday' do
    event =  Event.create!( name: 'every weekday event',
                            description: '',
                            is_all_day: false,
                            from_date: 'Mon, 17 Jun 2013',
                            from_time: '2000-01-01 09:00:00 UTC',
                            to_date: 'Mon, 17 Jun 2013',
                            to_time: '2000-01-01 17:00:00 UTC',
                            repeats: 'weekly',
                            repeats_every_n_days: nil,
                            repeats_every_n_weeks: 1,
                            repeats_weekly_each_days_of_the_week_mask: 62,
                            repeats_every_n_months: nil,
                            repeats_monthly: 'each',
                            repeats_every_n_years: nil,
                            repeats_yearly_on: false,
                            repeat_ends: 'never',
                            repeat_ends_on: 'Mon, 17 Jun 2013',
                            time_zone: 'Eastern Time (US & Canada)')
    expect(event.schedule.first(7)).to eq(['Mon, 17 Jun 2013 09:00:00 EDT -04:00i', 'Tue, 18 Jun 2013 09:00:00 EDT -04:00', 'Wed, 19 Jun 2013 09:00:00 EDT -04:00', 'Thu, 20 Jun 2013 09:00:00 EDT -04:00', 'Fri, 21 Jun 2013 09:00:00 EDT -04:00', 'Mon, 24 Jun 2013 09:00:00 EDT -04:00', 'Tue, 25 Jun 2013 09:00:00 EDT -04:00'])
    expect(event.schedule.first(5)).not_to eq(['Sat, 22 Jun 2013 09:00:00 EDT -04:00', 'Sun, 23 Jun 2013 09:00:00 EDT -04:00', 'Sat, 29 Jun 2013 09:00:00 EDT -04:00', 'Sun, 30 Jun 2013 09:00:00 EDT -04:00', 'Sat, 06 Jul 2013 09:00:00 EDT -04:00'])
  end

  it 'is scheduled for every weekend' do
    event =  Event.create!( name: 'every weekend event',
                            description: '',
                            is_all_day: false,
                            from_date: 'Mon, 17 Jun 2013',
                            from_time: '2000-01-01 09:00:00 UTC',
                            to_date: 'Mon, 17 Jun 2013',
                            to_time: '2000-01-01 17:00:00 UTC',
                            repeats: 'weekly',
                            repeats_every_n_days: nil,
                            repeats_every_n_weeks: 1,
                            repeats_weekly_each_days_of_the_week_mask: 65,
                            repeats_every_n_months: nil,
                            repeats_monthly: 'each',
                            repeats_every_n_years: nil,
                            repeats_yearly_on: false,
                            repeat_ends: 'never',
                            repeat_ends_on: 'Mon, 17 Jun 2013',
                            time_zone: 'Eastern Time (US & Canada)')
    expect(event.schedule.first(5)).to eq(['Sat, 22 Jun 2013 09:00:00 EDT -04:00', 'Sun, 23 Jun 2013 09:00:00 EDT -04:00', 'Sat, 29 Jun 2013 09:00:00 EDT -04:00', 'Sun, 30 Jun 2013 09:00:00 EDT -04:00', 'Sat, 06 Jul 2013 09:00:00 EDT -04:00'])
    expect(event.schedule.first(7)).not_to eq(['Mon, 17 Jun 2013 09:00:00 EDT -04:00i', 'Tue, 18 Jun 2013 09:00:00 EDT -04:00', 'Wed, 19 Jun 2013 09:00:00 EDT -04:00', 'Thu, 20 Jun 2013 09:00:00 EDT -04:00', 'Fri, 21 Jun 2013 09:00:00 EDT -04:00', 'Mon, 24 Jun 2013 09:00:00 EDT -04:00', 'Tue, 25 Jun 2013 09:00:00 EDT -04:00'])
  end

  it 'is scheduled for every Sunday' do
    event =  Event.create!( name: 'every Sunday event',
                            description: '',
                            is_all_day: false,
                            from_date: 'Mon, 17 Jun 2013',
                            from_time: '2000-01-01 09:00:00 UTC',
                            to_date: 'Mon, 17 Jun 2013',
                            to_time: '2000-01-01 17:00:00 UTC',
                            repeats: 'weekly',
                            repeats_every_n_days: nil,
                            repeats_every_n_weeks: 1,
                            repeats_weekly_each_days_of_the_week_mask: 1,
                            repeats_every_n_months: nil,
                            repeats_monthly: 'each',
                            repeats_every_n_years: nil,
                            repeats_yearly_on: false,
                            repeat_ends: 'never',
                            repeat_ends_on: 'Mon, 17 Jun 2013',
                            time_zone: 'Eastern Time (US & Canada)')
    expect(event.schedule.first(5)).to eq(['Sun, 23 Jun 2013 09:00:00 EDT -04:00', 'Sun, 30 Jun 2013 09:00:00 EDT -04:00', 'Sun, 07 Jul 2013 09:00:00 EDT -04:00', 'Sun, 14 Jul 2013 09:00:00 EDT -04:00', 'Sun, 21 Jul 2013 09:00:00 EDT -04:00'])
    expect(event.schedule.first(5)).not_to eq(['Mon, 17 Jun 2013 09:00:00 EDT -04:00', 'Mon, 24 Jun 2013 09:00:00 EDT -04:00', 'Mon, 01 Jul 2013 09:00:00 EDT -04:00', 'Mon, 08 Jul 2013 09:00:00 EDT -04:00', 'Mon, 15 Jul 2013 09:00:00 EDT -04:00'])
  end

  it 'is scheduled for every Monday' do
    event =  Event.create!( name: 'every Monday event',
                            description: '',
                            is_all_day: false,
                            from_date: 'Mon, 17 Jun 2013',
                            from_time: '2000-01-01 09:00:00 UTC',
                            to_date: 'Mon, 17 Jun 2013',
                            to_time: '2000-01-01 17:00:00 UTC',
                            repeats: 'weekly',
                            repeats_every_n_days: nil,
                            repeats_every_n_weeks: 1,
                            repeats_weekly_each_days_of_the_week_mask: 2,
                            repeats_every_n_months: nil,
                            repeats_monthly: 'each',
                            repeats_every_n_years: nil,
                            repeats_yearly_on: false,
                            repeat_ends: 'never',
                            repeat_ends_on: 'Mon, 17 Jun 2013',
                            time_zone: 'Eastern Time (US & Canada)')
    expect(event.schedule.first(5)).to eq(['Mon, 17 Jun 2013 09:00:00 EDT -04:00', 'Mon, 24 Jun 2013 09:00:00 EDT -04:00', 'Mon, 01 Jul 2013 09:00:00 EDT -04:00', 'Mon, 08 Jul 2013 09:00:00 EDT -04:00', 'Mon, 15 Jul 2013 09:00:00 EDT -04:00'])
    expect(event.schedule.first(5)).not_to eq(['Sun, 23 Jun 2013 09:00:00 EDT -04:00', 'Sun, 30 Jun 2013 09:00:00 EDT -04:00', 'Sun, 07 Jul 2013 09:00:00 EDT -04:00', 'Sun, 14 Jul 2013 09:00:00 EDT -04:00', 'Sun, 21 Jul 2013 09:00:00 EDT -04:00'])
  end

  it 'is scheduled for every first of the month' do
    event =  Event.create!( name: 'the first of the month',
                            description: '',
                            is_all_day: false,
                            from_date: 'Mon, 17 Jun 2013',
                            from_time: '2000-01-01 09:00:00 UTC',
                            to_date: 'Mon, 17 Jun 2013',
                            to_time: '2000-01-01 17:00:00 UTC',
                            repeats: 'monthly',
                            repeats_every_n_days: nil,
                            repeats_every_n_weeks: 1,
                            repeats_weekly_each_days_of_the_week_mask: 2,
                            repeats_every_n_months: 1,
                            repeats_monthly: 'each',
                            repeats_monthly_each_days_of_the_month_mask: 1,
                            repeats_monthly_on_ordinals_mask: 0,
                            repeats_monthly_on_days_of_the_week_mask: 0,
                            repeats_every_n_years: nil,
                            repeats_yearly_on: false,
                            repeat_ends: 'never',
                            repeat_ends_on: 'Mon, 17 Jun 2013',
                            time_zone: 'Eastern Time (US & Canada)')
    expect(event.schedule.first(5)).to eq(['Mon, 01 Jul 2013 09:00:00 EDT -04:00', 'Thu, 01 Aug 2013 09:00:00 EDT -04:00', 'Sun, 01 Sep 2013 09:00:00 EDT -04:00', 'Tue, 01 Oct 2013 09:00:00 EDT -04:00', 'Fri, 01 Nov 2013 09:00:00 EDT -04:00'])
    expect(event.schedule.first(5)).not_to eq(['Tue, 02 Jul 2013 09:00:00 EDT -04:00', 'Fri, 02 Aug 2013 09:00:00 EDT -04:00', 'Mon, 02 Sep 2013 09:00:00 EDT -04:00', 'Wed, 02 Oct 2013 09:00:00 EDT -04:00', 'Sat, 02 Nov 2013 09:00:00 EDT -04:00'])
  end

  it 'is scheduled for every first and 15th of the month' do
    event =  Event.create!( name: 'the first and 15th of the month',
                            description: '',
                            is_all_day: false,
                            from_date: 'Mon, 17 Jun 2013',
                            from_time: '2000-01-01 09:00:00 UTC',
                            to_date: 'Mon, 17 Jun 2013',
                            to_time: '2000-01-01 17:00:00 UTC',
                            repeats: 'monthly',
                            repeats_every_n_days: nil,
                            repeats_every_n_weeks: 1,
                            repeats_weekly_each_days_of_the_week_mask: 2,
                            repeats_every_n_months: 1,
                            repeats_monthly: 'each',
                            repeats_monthly_each_days_of_the_month_mask: 16385,
                            repeats_monthly_on_ordinals_mask: 0,
                            repeats_monthly_on_days_of_the_week_mask: 0,
                            repeats_every_n_years: nil,
                            repeats_yearly_on: false,
                            repeat_ends: 'never',
                            repeat_ends_on: 'Mon, 17 Jun 2013',
                            time_zone: 'Eastern Time (US & Canada)')
    expect(event.schedule.first(5)).to eq(['Mon, 01 Jul 2013 09:00:00 EDT -04:00', 'Mon, 15 Jul 2013 09:00:00 EDT -04:00', 'Thu, 01 Aug 2013 09:00:00 EDT -04:00', 'Thu, 15 Aug 2013 09:00:00 EDT -04:00', 'Sun, 01 Sep 2013 09:00:00 EDT -04:00'])
    expect(event.schedule.first(5)).not_to eq(['Wed, 03 Jul 2013 09:00:00 EDT -04:00', 'Thu, 04 Jul 2013 09:00:00 EDT -04:00', 'Fri, 05 Jul 2013 09:00:00 EDT -04:00', 'Sat, 06 Jul 2013 09:00:00 EDT -04:00', 'Sun, 07 Jul 2013 09:00:00 EDT -04:00'])
  end

  it 'is scheduled for every second friday of the month' do
    event =  Event.create!( name: 'the first and 15th of the month',
                            description: '',
                            is_all_day: false,
                            from_date: 'Mon, 17 Jun 2013',
                            from_time: '2000-01-01 09:00:00 UTC',
                            to_date: 'Mon, 17 Jun 2013',
                            to_time: '2000-01-01 17:00:00 UTC',
                            repeats: 'monthly',
                            repeats_every_n_days: nil,
                            repeats_every_n_weeks: 1,
                            repeats_weekly_each_days_of_the_week_mask: 2,
                            repeats_every_n_months: 1,
                            repeats_monthly: 'on',
                            repeats_monthly_each_days_of_the_month_mask: 16385,
                            repeats_monthly_on_ordinals_mask: 2,
                            repeats_monthly_on_days_of_the_week_mask: 32,
                            repeats_every_n_years: nil,
                            repeats_yearly_on: false,
                            repeat_ends: 'never',
                            repeat_ends_on: 'Mon, 17 Jun 2013',
                            time_zone: 'Eastern Time (US & Canada)')
    expect(event.schedule.first(5)).to eq(['Fri, 12 Jul 2013 09:00:00 EDT -04:00', 'Fri, 09 Aug 2013 09:00:00 EDT -04:00', 'Fri, 13 Sep 2013 09:00:00 EDT -04:00', 'Fri, 11 Oct 2013 09:00:00 EDT -04:00', 'Fri, 08 Nov 2013 09:00:00 EST -05:00'])
    expect(event.schedule.first(5)).not_to eq(['Fri, 05 Jul 2013 09:00:00 EDT -04:00', 'Fri, 02 Aug 2013 09:00:00 EDT -04:00', 'Fri, 06 Sep 2013 09:00:00 EDT -04:00', 'Fri, 04 Oct 2013 09:00:00 EDT -04:00', 'Fri, 01 Nov 2013 09:00:00 EDT -04:00'])
  end

  it 'is scheduled for every December' do
    event =  Event.create!( name: 'a special day in dec',
                            description: '',
                            is_all_day: false,
                            from_date: 'Mon, 17 Jun 2013',
                            from_time: '2000-01-01 09:00:00 UTC',
                            to_date: 'Mon, 17 Jun 2013',
                            to_time: '2000-01-01 17:00:00 UTC',
                            repeats: 'yearly',
                            repeats_every_n_days: nil,
                            repeats_every_n_weeks: 1,
                            repeats_weekly_each_days_of_the_week_mask: 2,
                            repeats_every_n_months: 1,
                            repeats_monthly: 'each',
                            repeats_monthly_each_days_of_the_month_mask: 16385,
                            repeats_monthly_on_ordinals_mask: 2,
                            repeats_monthly_on_days_of_the_week_mask: 32,
                            repeats_every_n_years: 1,
                            repeats_yearly_each_months_of_the_year_mask: 2048,
                            repeats_yearly_on: false,
                            repeat_ends: 'never',
                            repeat_ends_on: 'Mon, 17 Jun 2013',
                            time_zone: 'Eastern Time (US & Canada)')
    expect(event.schedule.first(5)).to eq(['Tue, 17 Dec 2013 09:00:00 EST -05:00', 'Wed, 17 Dec 2014 09:00:00 EST -05:00', 'Thu, 17 Dec 2015 09:00:00 EST -05:00', 'Sat, 17 Dec 2016 09:00:00 EST -05:00', 'Sun, 17 Dec 2017 09:00:00 EST -05:00'])
    expect(event.schedule.first(5)).not_to eq(['Mon, 16 Dec 2013 09:00:00 EST -05:00', 'Tue, 16 Dec 2014 09:00:00 EST -05:00', 'Wed, 16 Dec 2015 09:00:00 EST -05:00', 'Fri, 16 Dec 2016 09:00:00 EST -05:00', 'Sat, 16 Dec 2017 09:00:00 EST -05:00'])
  end

  it 'is scheduled for every third thursday' do
    event =  Event.create!( name: 'a special day in dec',
                            description: '',
                            is_all_day: false,
                            from_date: 'Mon, 17 Jun 2013',
                            from_time: '2000-01-01 09:00:00 UTC',
                            to_date: 'Mon, 17 Jun 2013',
                            to_time: '2000-01-01 17:00:00 UTC',
                            repeats: 'yearly',
                            repeats_every_n_days: nil,
                            repeats_every_n_weeks: 1,
                            repeats_weekly_each_days_of_the_week_mask: 2,
                            repeats_every_n_months: 1,
                            repeats_monthly: 'each',
                            repeats_monthly_each_days_of_the_month_mask: 16385,
                            repeats_monthly_on_ordinals_mask: 2,
                            repeats_monthly_on_days_of_the_week_mask: 32,
                            repeats_every_n_years: 1,
                            repeats_yearly_each_months_of_the_year_mask: 1024,
                            repeats_yearly_on: true,
                            repeats_yearly_on_ordinals_mask: 4,
                            repeats_yearly_on_days_of_the_week_mask: 48,
                            repeat_ends: 'never',
                            repeat_ends_on: 'Mon, 17 Jun 2013',
                            time_zone: 'Eastern Time (US & Canada)')
    expect(event.schedule.first(5)).to eq(['Fri, 15 Nov 2013 09:00:00 EST -05:00', 'Thu, 21 Nov 2013 09:00:00 EST -05:00', 'Thu, 20 Nov 2014 09:00:00 EST -05:00', 'Fri, 21 Nov 2014 09:00:00 EST -05:00', 'Thu, 19 Nov 2015 09:00:00 EST -05:00'])
    expect(event.schedule.first(5)).not_to eq(['Thu, 20 Jun 2013 09:00:00 EDT -04:00', 'Fri, 21 Jun 2013 09:00:00 EDT -04:00', 'Thu, 18 Jul 2013 09:00:00 EDT -04:00', 'Fri, 19 Jul 2013 09:00:00 EDT -04:00', 'Thu, 15 Aug 2013 09:00:00 EDT -04:00'])
  end
end
