require 'spec_helper'

describe 'events/show' do
  before(:each) do
    ENV['TZ'] = 'UTC'
    Delorean.time_travel_to(Time.parse('Mon, 17 Feb 2013'))
    @event = stub_model(Event, name: 'EuroAsia Scrum',
                        category: 'Scrum',
                        description: 'EuroAsia Scrum and Pair hookup',
                        event_date: 'Mon, 17 Feb 2013',
                        start_time: '2000-01-01 09:00:00 UTC',
                        end_time: '2000-01-01 09:30:00 UTC',
                        updated_at: Time.now,
                        repeats: 'daily',
                        repeats_every_n_days: 1,
                        repeat_ends: 'never',
                        repeat_ends_on: 'Mon, 17 Jun 2014',
                        time_zone: 'Eastern Time (US & Canada)')
    @event_schedule = @event.current_occurences
    render
  end

  after (:each) do
    Delorean.back_to_the_present
  end

  it 'should display event information' do
    rendered.should have_text 'EuroAsia Scrum'
    rendered.should have_text 'EuroAsia Scrum and Pair hookup'
  end

  it 'should render the event name' do
    render
    rendered.should have_text @event.name
  end

  it 'should render the event description' do
    render
    rendered.should have_text @event.description
  end

  it 'should render dates and time for 5 upcoming events' do
    render
    rendered.should have_text 'Upcoming schedule'
    @event_schedule.first(5).each do |e|
      rendered.should have_content nested_hash_value(e, :time).strftime('%F at %I:%M%p')
    end
  end

  it 'should display HOA url if url is set' do
    @event.url = 'http://google.com'
    render
    rendered.should have_text 'Hangout link'
    rendered.should have_css '#hoa-link'
    rendered.should have_link @event.url
  end

  it 'should not display HOA url if url is NIL' do
    @event.url = nil
    render
    rendered.should_not have_text 'Hangout link:'
    rendered.should_not have_selector('a#hoa-link')
  end

  it 'logged in user should see Edit link' do
    view.stub(:user_signed_in?).and_return(true)
    render
    rendered.should have_link 'Edit'
  end

  it 'logged in user should see add/edit url form' do
    view.stub(:user_signed_in?).and_return(true)
    render
    rendered.should have_selector('form#event-form')
  end
end