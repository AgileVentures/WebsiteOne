require 'spec_helper'

describe 'Events/show' do
  before(:each) do
    ENV['TZ'] = 'UTC'
    Delorean.time_travel_to(Time.parse('Mon, 16 Feb 2013'))
    @event = stub_model(Event, id: '1001', name: 'EuroAsia Scrum',
                        category: 'Scrum',
                        description: 'EuroAsia Scrum and Pair hookup',
                        event_date: 'Mon, 17 Feb 2013',
                        start_time: '2000-01-01 09:00:00 UTC',
                        end_time: '2000-01-01 09:30:00 UTC',
                        repeats: 'never',
                        repeats_every_n_weeks: 1,
                        repeats_weekly_each_days_of_the_week_mask: 96,
                        repeat_ends: 'never',
                        repeat_ends_on: 'Tue, 25 Jun 2013',
                        time_zone: 'Eastern Time (US & Canada)')

    @event_schedule = @event.current_occurences
    assign(:event, @event)
    assign(:id, @event.id)
    assign(:event_schedule, @event_schedule)

  end
  after (:each) do
    Delorean.back_to_the_present
  end
  it 'should display event information' do
    render
    rendered.should have_text 'EuroAsia Scrum'
    rendered.should have_text 'EuroAsia Scrum and Pair hookup'
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
    rendered.should have_text 'Hangout link:'
    rendered.should have_css('a#hoa-link')
    rendered.should have_link @event.url
  end
  it 'should not display HOA url if url is NIL' do
    @event.url = nil
    render
    rendered.should_not have_text 'Hangout link:'
    rendered.should_not have_selector('a#hoa-link')
  end

  #it 'logged in user should see Edit link' do
  #  debugger
  #  view.stub(:user_signed_in?).and_return(true)
  #  render
  #  rendered.should have_link 'Edit'
  #end
  #
  #it 'logged in user should see add/edit url form' do
  #  view.stub(:user_signed_in?).and_return(true)
  #  render
  #  rendered.should have_selector('form#event-form')
  #end
end