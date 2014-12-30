require 'spec_helper'
require 'end_time'
require 'start_time'

describe EndTime, :type => :model do
  it 'returns default start time for event + 30 mins if end time is blank' do
    allow(StartTime).to receive(:for).with(nil).and_return(Time.now)
    expect(EndTime.for(nil).to_i).to eq (Time.now + 30.minutes).to_i
  end

  it 'returns end time if end time is present' do
    expect(EndTime.for(5.hours.from_now).to_i).to eq 5.hours.from_now.to_i
  end
end
