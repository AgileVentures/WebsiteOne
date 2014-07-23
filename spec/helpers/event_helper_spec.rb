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

  it 'extract event ocurrence from hash' do
    ocurrence = Time.utc(2014,"mar",9,23,0,0)
    time = IceCube::Occurrence.new(ocurrence)
    event = mock_model(Event, name: 'DailyScrum', category: 'Scrum')
    nested_value = {:event => event, :time => time}
    result = helper.current_occurrence_time(nested_value)
    expect(result).to match /Sunday, 9th Mar at 11:00pm \(UTC\)/
  end
end
