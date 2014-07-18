require 'spec_helper'

describe Hangout do
  let(:event){ FactoryGirl.build_stubbed(:event, start_time: Time.parse('10:00:00')) }
  let(:hangout){ Hangout.new(event_id: '333', event: event, updated_at: Time.now) }

  it '#started?' do
    allow(Time).to receive(:now).and_return(Time.parse('11:00:00'))
    hangout.hangout_url = 'test'
    expect(hangout.started?).to be_truthy
  end

  it '#live?' do
    allow(Time).to receive(:now).and_return(Time.parse('10:10:00'))
    hangout.hangout_url = 'test'
    expect(hangout.live?).to be_truthy
  end

  describe '#update_hangout_data' do
    let(:params) do
      { title: 'Scrum', hangout_url: 'http://hangout.test' }
    end

    it 'updates basic data' do
      hangout.update_hangout_data(params)
      expect(hangout.hangout_url).to eq 'http://hangout.test'
    end

  end
end
