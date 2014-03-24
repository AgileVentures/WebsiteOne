require 'spec_helper'

describe 'visitors/index.html.erb' do
  before :each do
    @default_tz = ENV['TZ']
    ENV['TZ'] = 'UTC'
  end

  after :each do
    Delorean.back_to_the_present
    ENV['TZ'] = @default_tz
  end

  it 'should render round banners' do
    render
    expect(rendered).to render_template(:partial => '_round_banners')
  end

  context 'event is planned for next day' do
    before :each do
      Delorean.time_travel_to(Time.parse('2014-03-05 09:15:00 UTC'))
      #@event = FactoryGirl.create(:event, name: 'Spec Scrum', event_date: '2014-03-07', start_time: '23:30:00')
      @event = stub_model(Event, name: 'Spec Scrum', event_date: '2014-03-07', start_time: '23:30:00')
      assign :event, @event

    end

    it 'should display countdown' do
      render
      expect(rendered).to have_link @event.name, event_path(@event)
      expect(rendered).to have_text [@event.name, 'in'].join(' ')
      expect(rendered).to have_text [@days_left, 'days'].join(' ')
      expect(rendered).to have_text [@hours_left, 'hours'].join(' ')
      expect(rendered).to have_text [@minutes_left, 'minutes'].join(' ')
    end
  end


  context 'event is planned for same day' do
    before :each do
      Delorean.time_travel_to(Time.parse('2014-03-07 09:15:00 UTC'))
      #@event = FactoryGirl.create(:event, name: 'Spec Scrum', event_date: '2014-03-07', start_time: '23:30:00')
      @event = stub_model(Event, name: 'Spec Scrum', event_date: '2014-03-07', start_time: '10:30:00')
    end

    it 'should display countdown' do
      assign :event, @event
      assign :count_down, [@event]
      assign :days_left, 0
      assign :hours_left, 1
      assign :minutes_left, 15
      render
      expect(rendered).to have_link @event.name, event_path(@event)
      expect(rendered).to have_text [@event.name, 'in'].join(' ')
      expect(rendered).to_not have_text '0 days'
      expect(rendered).to have_text '1 hours'
      expect(rendered).to have_text '15 minutes'
    end

  end
end

