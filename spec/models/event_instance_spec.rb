require 'spec_helper'

describe EventInstance, type: :model do
  let(:hangout) { FactoryGirl.create(:event_instance, updated: '10:00 UTC', hangout_url: nil) }

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

  context 'hangout_url is present and is not finished' do
    before do
      hangout.hangout_url = 'test'
      hangout.hoa_status = 'anything'
    end

    it 'reports live if the link is not older than 2 minutes and hoa_status' do
      allow(Time).to receive(:now).and_return(Time.mktime('10:01:59'))
      expect(hangout.live?).to be_truthy
    end

    it 'reports not live if the link is older than 2 minutes and hoa_status' do
      allow(Time).to receive(:now).and_return(Time.parse('10:02:01 UTC'))
      expect(hangout.live?).to be_falsey
    end
  end

  context 'hangout_url is present and hoa_status is finished' do
    before do
      hangout.hangout_url = 'test'
      hangout.hoa_status = 'finished'
    end

    it 'reports not live if the link is not older than 2 minutes' do
      allow(Time).to receive(:now).and_return(Time.mktime('10:01:59'))
      expect(hangout.live?).to be_falsey
    end

    it 'reports not live if the link is older than 2 minutes' do
      allow(Time).to receive(:now).and_return(Time.parse('10:02:01 UTC'))
      expect(hangout.live?).to be_falsey
    end
  end

  context 'validation: dont update after finished' do
    it 'when hoa_status is "finished" should not be updated' do
      hangout.hangout_url = 'test'
      hangout.hoa_status = 'finished'
      hangout.save
      hangout.reload
      expect(hangout.update(hoa_status: 'finished')).to be_falsey
    end

    it 'when hoa_status is not "finished" it is updated' do
      hangout.hangout_url = 'test'
      hangout.hoa_status = 'broadcasting'
      hangout.save
      hangout.reload
      expect(hangout.update(hoa_status: 'finished')).to be_truthy
    end
  end
end
