require 'spec_helper'

describe 'Events/show' do
  before(:each) do
    ENV['TZ'] = 'UTC'
    Delorean.time_travel_to(Time.parse('Mon, 17 Feb 2013'))
    @event = stub_model(Event, name: 'EuroAsia Scrum',
                         category: 'Scrum',
                         description: 'EuroAsia Scrum and Pair hookup',
                         event_date: 'Mon, 17 Feb 2013',
                         start_time: '2000-01-01 09:00:00 UTC',
                         end_time: '2000-01-01 09:30:00 UTC',
                         repeats: 'daily',
                         repeats_every_n_days: 1,
                         repeat_ends: 'never',
                         repeat_ends_on: 'Mon, 17 Jun 2014',
                         time_zone: 'Eastern Time (US & Canada)')
  end
  after (:each) do
    Delorean.back_to_the_present
  end
  it 'should display event information' do
    render
    debugger
    rendered.should have_text 'EuroAsia Scrum'
    rendered.should have_text 'EuroAsia Scrum and Pair hookup'
  end
end