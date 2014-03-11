require 'spec_helper'

describe 'visitors/index.html.erb' do
  before :each do
    @event = FactoryGirl.create(:event)
    @default_tz = ENV['TZ']
    ENV['TZ'] = 'UTC'
    Delorean.time_travel_to(Time.parse("2014-03-07 09:15:00 UTC"))
  end

  after :each do
    Delorean.back_to_the_present
    ENV['TZ'] = @default_tz
  end

  it 'should render round banners' do
    render
    expect(rendered).to render_template(:partial => '_round_banners')
  end

  it 'should display countdown to next scrum' do
    render
    expect(rendered).to have_link @event.name, event_path(@event)
    expect(rendered).to have_text [@event.name, 'in'].join(' ')
    expect(rendered).to have_text [@days_left, 'days'].join(' ')
    expect(rendered).to have_text [@hours_left, 'hours'].join(' ')
    expect(rendered).to have_text [@minutes_left, 'minutes'].join(' ')
  end
end

