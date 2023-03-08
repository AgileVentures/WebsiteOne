# frozen_string_literal: true

describe VisitorsHelper do
  describe '#display_countdown' do
    before :each do
      @default_tz = ENV.fetch('TZ', nil)
      ENV['TZ'] = 'UTC'
    end

    after :each do
      Delorean.back_to_the_present
      ENV['TZ'] = @default_tz
    end

    it 'should display countdown based on input' do
      Delorean.time_travel_to(Time.parse('2014-03-05 09:15:00 UTC'))
      @event = stub_model(Event,
                          next_occurrence_time_attr: double(IceCube::Occurrence,
                                                            to_datetime: DateTime.parse('2014-03-07 10:30:00 UTC')))
      expect(helper.display_countdown(@event)).to eq '2 days 1 hour 15 minutes'
    end
    it 'should display countdown based on input and remove days when 0' do
      Delorean.time_travel_to(Time.parse('2014-03-07 09:15:00 UTC'))
      @event = stub_model(Event,
                          next_occurrence_time_attr: double(IceCube::Occurrence,
                                                            to_datetime: DateTime.parse('2014-03-07 10:30:00 UTC')))
      expect(helper.display_countdown(@event)).to eq '1 hour 15 minutes'
    end
  end
end
