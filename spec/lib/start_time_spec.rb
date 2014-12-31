require 'spec_helper'
require 'start_time'

describe StartTime do
  it 'returns 30 minutes ago if start time is blank' do
    expect(StartTime.for(nil).to_i).to eq 30.minutes.ago.to_i
  end

  it 'returns start time if start time is present' do
    expect(StartTime.for(5.hours.from_now).to_i).to eq 5.hours.from_now.to_i
  end
end
