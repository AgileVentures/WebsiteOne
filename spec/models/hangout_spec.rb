require 'spec_helper'

describe Hangout do
  let(:event){ FactoryGirl.build_stubbed(:event, start_time: Time.parse('10:00:00')) }
  let(:hangout){Hangout.new(event_id: '333', event: event, updated_at: Time.parse('10:00:00')) }

  context 'hangout_url is not present' do
    it '#started? returns nil' do
      expect(hangout.started?).to be_falsey
    end

    it '#live? returns nil' do
      expect(hangout.live?).to be_falsey
    end
  end

  context 'hangout_url is present' do
    before { hangout.hangout_url = 'test' }

    it 'reports started if the link is not older than 2 hours' do
      allow(Time).to receive(:now).and_return(Time.parse('10:59:59'))
      expect(hangout.started?).to be_truthy
    end

    it 'reports not started if the link is older than 2 hours' do
      allow(Time).to receive(:now).and_return(Time.parse('12:00:01'))
      expect(hangout.started?).to be_falsey
    end

    it 'reports live if the link is not older than 15 minutes' do
      allow(Time).to receive(:now).and_return(Time.parse('10:14:59'))
      expect(hangout.live?).to be_truthy
    end

    it 'reports not live if the link is older than 15 minutes' do
      allow(Time).to receive(:now).and_return(Time.parse('10:15:01'))
      expect(hangout.live?).to be_falsey
    end
  end

  describe '#update_hangout_data' do
    let(:params) do
      { title: 'Morning Rejoice',
        category: 'Scrum',
        hangout_url: 'http://hangout.test' }
    end

    it 'updates basic data' do
      hangout.update_hangout_data(params)

      expect(hangout.title).to eq 'Morning Rejoice'
      expect(hangout.hangout_url).to eq 'http://hangout.test'
    end

  end
end
