# frozen_string_literal: true

RSpec.describe EventDate, type: :model do
  it 'is expected to return todays date if given nil as argument' do
    expect(EventDate.for(nil)).to eq Date.today
  end

  it 'is expected to return date if given date as argument' do
    expect(EventDate.for(Date.tomorrow)).to eq Date.tomorrow
  end
end
