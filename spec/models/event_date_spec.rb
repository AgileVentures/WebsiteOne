require 'spec_helper'

describe EventDate, :type => :model do
  it 'returns todays date if event_date is nil' do
    expect(EventDate.for(nil)).to eq Date.today
  end

  it 'returns event_date if event_date is present' do
    expect(EventDate.for(Date.tomorrow)).to eq Date.tomorrow
  end
end