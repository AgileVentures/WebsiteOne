require 'spec_helper'

describe EventHelper do
  it 'cover_for PairProgramming' do
    event = mock_model(Event, category: 'PairProgramming')
    result = helper.cover_for(event)
    expect(result).to match(/event-pairwithme-cover\.png/)
  end

  it 'cover_for Scrum' do
    event = mock_model(Event, category: 'Scrum')
    result = helper.cover_for(event)
    expect(result).to match(/event-scrum-cover\.png/)
  end

  it 'extract event ocurrence from hash' do
    ocurrence = Time.utc(2014, 'mar', 9, 23, 0, 0)
    time = IceCube::Occurrence.new(ocurrence)
    event = mock_model(Event, name: 'DailyScrum', category: 'Scrum')
    nested_value = { event: event, time: time }
    result = helper.current_occurrence_time(nested_value)
    expect(result).to match(/Sunday, 9th Mar at 11:00pm \(UTC\)/)
  end

  it 'should wrap the current event time with a time tag when calling format_local_time' do
    datetime = Time.utc(2014, 'mar', 9, 23, 0, 0)
    result = helper.format_local_time(datetime)
    expect(result).to match(/<time datetime="2014-03-09T23:00:00Z" data-local="time" data-format="%l:%M %p \(%Z\)">11:00 PM \(UTC\)<\/time>/)
  end

  describe 'start prefix' do
    it 'returns \'Started at\' for past time' do
      time = Time.now - 4.minutes
      expect(helper.start_prefix(time)).to eql 'Started at '
    end

    it 'returns \'Start at\' for future time' do
      time = Time.now + 4.minutes
      expect(helper.start_prefix(time)).to eql 'Starts at '
    end
  end

  describe 'end prefix' do
    it 'returns \'Ended at\' for past time' do
      time = Time.now - 4.minutes
      expect(helper.end_prefix(time)).to eql 'Ended at '
    end

    it 'returns \'Ends at\' for future time' do
      time = Time.now + 4.minutes
      expect(helper.end_prefix(time)).to eql 'Ends at '
    end
  end

  describe 'time ranges' do
    let(:current_time) { Time.utc(2016, 2, 9, 19, 0, 0) }
    let(:event) do
      double(:event,
             start_time: current_time,
             duration: 15.minutes,
             instance_end_time: current_time + 15.minutes)
    end

    before { Delorean.time_travel_to(current_time - 15.minutes) }

    after { Delorean.back_to_the_present }

    it 'returns a UTC time range' do
      expected_result = 'Starts at 19:00  -  Ends at 19:15 (UTC)'
      actual_result = helper.show_time_range(event)
      expect(expected_result).to eql actual_result
    end

    it 'returns a local time range' do
      expected_result = \
        '<time datetime="2016-02-09T19:00:00Z" data-local="time" '\
        'data-format="%H:%M">19:00</time>-<time ' \
        'datetime="2016-02-10T10:00:00Z" data-local="time" ' \
        'data-format="%H:%M (%Z)">10:00 (UTC)</time>'

      actual_result = helper.show_local_time_range(current_time, event.duration)
      expect(actual_result).to eql expected_result
    end
  end
end
