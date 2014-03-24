require 'spec_helper'

describe 'visitors/index.html.erb' do
  before :each do
    @default_tz = ENV['TZ']
    ENV['TZ'] = 'UTC'
    @event = stub_model(Event, name: 'Spec Scrum', event_date: '2014-03-07', start_time: '10:30:00', next_occurrence_time: double(IceCube::Occurrence, to_datetime:DateTime.parse('2014-03-07 10:30:00 UTC')))
    assign :event, @event
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
    end

    it 'should display countdown' do
      render
      expect(rendered).to have_link @event.name, event_path(@event)
      expect(rendered).to have_text [@event.name, 'in'].join(' ')
      expect(rendered).to have_text '2 days'
      expect(rendered).to have_text '1 hours'
      expect(rendered).to have_text '15 minutes'
    end
  end

  context 'event is planned for same day' do
    before :each do
      Delorean.time_travel_to(Time.parse('2014-03-07 09:15:00 UTC'))
    end

    it 'should display countdown but skip the "O days"' do
      render
      expect(rendered).to have_link @event.name, event_path(@event)
      expect(rendered).to have_text [@event.name, 'in'].join(' ')
      expect(rendered).to_not have_text '0 days'
      expect(rendered).to have_text '1 hours'
      expect(rendered).to have_text '15 minutes'
    end
  end
end

