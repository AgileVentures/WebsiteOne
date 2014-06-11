require 'spec_helper'

describe Hangout do
  let(:hangout){ stub_model(Hangout, event_id: '333') }

  it '#started?' do
    hangout.hangout_url = 'test'
    expect(hangout.started?).to be_true
  end

  describe '#update_hangout_data' do
    let(:params){
      { title: 'Scrum',
        hangout_url: 'http://hangout.test'
    }
    }
    it 'updates basic data' do
      hangout.update_hangout_data(params)
      expect(hangout.hangout_url).to eq 'http://hangout.test'
    end

  end
end
