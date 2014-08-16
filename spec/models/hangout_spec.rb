require 'spec_helper'

describe Hangout do
  let(:event){ FactoryGirl.build_stubbed(:event, start_datetime: Time.parse('2014-03-07 10:00:00 UTC')) }
  let(:hangout){Hangout.new(event_id: '333', event: event, updated_at: Time.parse('10:00:00')) }

  context 'hangout_url is not present' do
    it '#started? returns falsey' do
      expect(hangout.started?).to be_falsey
    end

    it '#live? returns false' do
      expect(hangout.live?).to be_falsey
    end

    it '#expired? returns false' do
      expect(hangout.expired?).to be_falsey
    end
  end

  context 'hangout_url is present' do
    before { hangout.hangout_url = 'test' }

    it 'reports live if the link is not older than 15 minutes' do
      allow(Time).to receive(:now).and_return(Time.parse('10:04:59'))
      expect(hangout.live?).to be_truthy
    end

    it 'reports not live if the link is older than 15 minutes' do
      allow(Time).to receive(:now).and_return(Time.parse('10:05:01'))
      expect(hangout.live?).to be_falsey
    end

    it 'reports expired if the link is older than 15 minutes' do
      allow(Time).to receive(:now).and_return(Time.parse('10:05:01'))
      expect(hangout.expired?).to be_truthy
    end
  end

  describe '#update_hangout_data' do
    let(:params) do
      { topic: 'Morning Rejoice',
        category: 'Scrum',
        hangout_url: 'http://hangout.test' }
    end

    it 'updates basic data' do
      event = FactoryGirl.create(:event)
      params[:event_id] = event.id
      current_time = Time.parse('10:02:00')
      allow(Time).to receive(:now).and_return(current_time)

      hangout.update_hangout_data(params)

      expect(hangout.title).to eq('Morning Rejoice')
      expect(hangout.event).to eq(event)
      expect(hangout.category).to eq('Scrum')
      expect(hangout.hangout_url).to eq('http://hangout.test')
      expect(hangout.updated_at.time).to eq(current_time)
    end

  end
end
