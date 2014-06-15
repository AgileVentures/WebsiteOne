require 'spec_helper'

describe EndTime do
  it 'returns default start time for event + 30 mins if end time is blank' do
    StartTime.should_receive(:for).with(nil).and_return(Time.now)
    expect(EndTime.for(nil).to_s).to eq (Time.now + 30.minutes).to_s
  end

  it 'returns end time if end time is present' do
    expect(EndTime.for(5.hours.from_now.to_s)).to eq 5.hours.from_now.to_s
  end
end