require 'spec_helper'

describe 'events/index', type: :view do
  before(:each) do
    Delorean.time_travel_to(Time.parse('Mon, 17 Feb 2013'))
    @event1 = FactoryGirl.build_stubbed(:event, name: 'EuroAsia Scrum',
                         category: 'Scrum',
                         description: 'EuroAsia Scrum and Pair hookup',
                         start_datetime: 'Mon, 17 Feb 2013 09:00:00 UTC',
                         duration: 30,
                         repeats: 'never',
                         repeats_every_n_weeks: nil,
                         repeat_ends: 'never',
                         repeat_ends_on: 'Mon, 17 Jun 2014',
                         time_zone: 'UTC')

    @event2 = FactoryGirl.build_stubbed(:event, name: 'Daily Scrum',
                         category: 'Scrum',
                         description: 'Daily Scrum and Pair hookup',
                         start_datetime: 'Mon, 17 Feb 2013 16:00:00 UTC',
                         duration: 30,
                         repeats: 'weekly',
                         repeats_every_n_weeks: 1,
                         repeat_ends: 'never',
                         repeat_ends_on: 'Mon, 17 Jun 2014',
                         time_zone: 'Eastern Time (US & Canada)')


    @events = [@event1.next_occurrences, @event2.next_occurrences]
    assign(:events, @events.flatten!)
  end

  context 'for signed in and not signed in users' do
    it 'renders a list of events' do
      render
      rendered.should have_text 'AgileVentures Events'
      @events.each do |event|
        event = event[:event]
        event_time = event.start_time_with_timezone.strftime('%k:%M %Z')
        expect(rendered).to have_link(event.name, :href => event_path(event))
        expect(rendered).to have_content("Starts at #{event_time}")
      end
    end

      it 'renders Started at for an event in progress' do
        allow(Time).to receive(:now).and_return(Time.parse('09:10:00 UTC'))
        render
        expect(rendered).to have_content("Started at 9:00")
      end
  end

  context 'for signed in users' do
    before :each do
      allow(view).to receive(:user_signed_in?).and_return(true)
    end
    it 'renders a "New Event" link' do
      render
      expect(rendered).to have_link('New Event', :href => new_event_path)
    end
  end

  context 'for visitors' do
    before :each do
      allow(view).to receive(:user_signed_in?).and_return(false)
    end
    it 'should NOT render a "New Event" link' do
      render
      expect(rendered).not_to have_link('New Event', :href => new_event_path)
    end
  end
end



