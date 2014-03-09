require 'spec_helper'

describe EventHelper do
  it 'cover_for PairProgramming' do
    event = mock_model(Event, category: 'PairProgramming')
    result = helper.cover_for(event)
    expect(result).to match /event-pairwithme-cover\.png/
  end

  it 'cover_for Scrum' do
    event = mock_model(Event, category: 'Scrum')
    result = helper.cover_for(event)
    expect(result).to match /event-scrum-cover\.png/
  end
end
