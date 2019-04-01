require 'spec_helper'

describe EventInstance, type: :model do
  let(:hangout) { FactoryBot.create(:event_instance, updated: '10:00 UTC', hangout_url: nil) }

  it 'has url_set_directly default to false' do
    expect(hangout.url_set_directly).to be_falsey
  end

  it { should delegate_method(:within_current_event_duration?).to(:event) }

  context '#updated_within_last_two_minutes?' do
    it 'should return false when updated_at is more than two minutes ago' do
      allow(Time).to receive(:now).and_return(Time.mktime('10:02:59'))
      expect(hangout).to be_updated_within_last_two_minutes
    end

    it 'should return true when updated_at is less than two minutes ago' do
      allow(Time).to receive(:now).and_return(Time.mktime('10:01:59'))
      expect(hangout).to be_updated_within_last_two_minutes
    end
  end

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

    context 'url manually overridden' do
      before do
        hangout.url_set_directly = true
        allow(hangout.event).to receive(:current_start_time).and_return(Time.parse('10:00 UTC'))
        allow(hangout.event).to receive(:current_end_time).and_return(Time.parse('10:30 UTC'))
      end

      it 'does not report live when link not updated' do
        allow(Time).to receive(:now).and_return(Time.parse('10:02 UTC'))
        allow(hangout).to receive(:updated_at).and_return(Time.parse('9:30 UTC'))
        expect(hangout.live?).to be_falsey
      end
      
      it 'report live when link is updated' do
        allow(Time).to receive(:now).and_return(Time.parse('10:02 UTC'))
        allow(hangout).to receive(:updated_at).and_return(Time.parse('10:01 UTC'))
        expect(hangout.live?).to be_truthy
      end

      it 'does not report live when event ends' do
        allow(Time).to receive(:now).and_return(Time.parse('10:31 UTC'))
        allow(hangout).to receive(:updated_at).and_return(Time.parse('10:01 UTC'))
        expect(hangout.live?).to be_falsey
      end

      it 'reports live when link is updated 10 min before start time' do
        allow(Time).to receive(:now).and_return(Time.parse('9:58 UTC'))
        allow(hangout).to receive(:updated_at).and_return(Time.parse('09:51 UTC'))
        expect(hangout.live?).to be_truthy        
      end
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

  context 'associated hangout_participant_snapshots' do
    let(:hangout) { FactoryBot.create(:event_instance, updated: '10:00 UTC', hangout_url: nil,
                                       hangout_participants_snapshots_attributes: [{participants: "blah"}]) }
    it 'should do stuff' do
      expect(hangout.hangout_participants_snapshots.count).to eq 1
    end

    it 'should add more hangout snapshots when updated' do
      hangout.update(hangout_participants_snapshots_attributes: [{participants: "stuff"}])
      expect(hangout.hangout_participants_snapshots.count).to eq 2
    end
  end
  
  context '.yt_url' do
    it 'should return youtube link from youtube id' do
      hangout.yt_video_id = 'mLBSQV-h-xo'
      expect(hangout.yt_url).to eq 'https://youtu.be/mLBSQV-h-xo'
    end
    
    it 'should return nil if youtube id is nil' do
      hangout.yt_video_id = nil
      expect(hangout.yt_url).to eq nil
    end
  end
end
