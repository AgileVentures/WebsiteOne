require 'spec_helper'

describe EventHelper do

  it 'extract event ocurrence from hash' do
    ocurrence = Time.utc(2014, 'mar', 9, 23, 0, 0)
    time = IceCube::Occurrence.new(ocurrence)
    event = mock_model(Event, name: 'DailyScrum', category: 'Scrum')
    nested_value = { event: event, time: time }
    result = helper.current_occurrence_time(nested_value)
    expect(result).to match(/Sunday, 9th Mar at 11:00pm \(UTC\)/)
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

  describe 'set_column_width' do
    it 'should be col-sm-2 when modifier_id exists' do
      @event = FactoryBot.build(:event, name: 'Spec Scrum', modifier_id: 1)
      expect(set_column_width).to eq('<div class="col-xs-12 col-sm-2"></div>')
    end

    it 'should be col-sm-4 when modifier_id does not exist' do
      @event = FactoryBot.build(:event, name: 'Spec Scrum')
      expect(set_column_width).to eq('<div class="col-xs-12 col-sm-4"></div>')
    end
  end
end
