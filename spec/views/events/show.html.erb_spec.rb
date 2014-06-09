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
    @event_schedule = @event.next_occurrences
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
    rendered.should have_text @event.name
  end

  it 'should render the event description' do
    rendered.should have_text @event.description
  end

  it 'should render dates and time for 5 upcoming events' do
    rendered.should have_text 'Upcoming schedule'
    @event_schedule.first(5).each do |e|
      rendered.should have_content nested_hash_value(e, :time).strftime('%F at %I:%M%p')
    end
  end

  describe 'Hangout status' do
    before(:each) do
      @video = stub_model(Video, video_id: 375,
                             host: 'Superman',
                             status: 'In progress',
                             hangout_url: 'http://hangout.test',
                             youtube_id: 'asd234',
                             created_at: '2014-06-10 10:30:00',
                             currently_in: %w(Sam Yaro),
                             participants: %w(Sam Yaro David),
                             started?: true,
                             live?: true)
      assign :video, @video
    end

    it 'renders Hangout status section if the hangout has started' do
      render
      expect(rendered).to have_css("#hangout_status")
    end


    it 'does not render Hangout status section if the hangout has not started' do
      @video.stub(started?: false)
      render
      expect(rendered).not_to have_css("#hangout_status")
    end

    it 'renders Hangout details headings' do
      render

      expect(rendered).to have_text('Status')
      expect(rendered).to have_text('Host')
      expect(rendered).to have_text('Youtube recording')
      expect(rendered).to have_text('Start time')
      expect(rendered).to have_text('Currently in')
      expect(rendered).to have_text('Participants')
    end

    it 'renders Hangout details values' do
      render

      expect(rendered).to have_text('In progress')
      expect(rendered).to have_text('Superman')
      expect(rendered).to have_text('10:30')
      expect(rendered).to have_text('Sam Yaro')
      expect(rendered).to have_text('Sam Yaro David')
      expect(rendered).to have_link 'Click to join the hangout', @video.hangout_url
      expect(rendered).to have_link 'Click to watch', /@video.youtube_id/
    end
  end
end
