require 'spec_helper'

describe EventInstance, type: :model do
  let(:hangout){ FactoryGirl.create(:event_instance, updated: '10:00 UTC', hangout_url: nil) }

  context 'hangout_url is not present' do
    before do
      allow(Time).to receive(:now).and_return(Time.parse('01:00 UTC'))
    end

    it '#started? returns falsey' do
      expect(hangout.started?).to be_falsey
    end

    it '#live? returns false' do
      expect(hangout.live?).to be_falsey
    end
  end

  context 'hangout_url is present' do
    before { hangout.hangout_url = 'test' }

    it 'reports live if the link is not older than 5 minutes' do
      allow(Time).to receive(:now).and_return(Time.mktime('10:04:59'))
      expect(hangout.live?).to be_truthy
    end

    it 'reports not live if the link is older than 5 minutes' do
      allow(Time).to receive(:now).and_return(Time.parse('10:05:01 UTC'))
      expect(hangout.live?).to be_falsey
    end
  end

end
