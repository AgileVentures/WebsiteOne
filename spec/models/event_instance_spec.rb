# frozen_string_literal: true

RSpec.describe EventInstance, type: :model do
  let!(:project) { create(:project) }
  let!(:creator) { create(:user) }
  let(:event) { create :event }
  subject do
    create(:event_instance,
           updated: '10:00 UTC',
           hangout_url: nil,
           event: event)
  end
  it 'has url_set_directly default to false' do
    expect(subject.url_set_directly).to be_falsey
  end

  it { is_expected.to delegate_method(:within_current_event_duration?).to(:event) }

  context '#updated_within_last_two_minutes?' do
    it 'is expected to return false when updated_at is more than two minutes ago' do
      allow(Time).to receive(:now).and_return(Time.mktime('10:01:59'))
      expect(subject).to be_updated_within_last_two_minutes
    end

    it 'is expected to  return true when updated_at is less than two minutes ago' do
      allow(Time).to receive(:now).and_return(Time.mktime('10:01:59'))
      expect(subject).to be_updated_within_last_two_minutes
    end
  end

  context 'hangout_url is not present' do
    before do
      allow(Time).to receive(:now).and_return(Time.parse('01:00 UTC'))
    end

    describe '#started?' do
      it {  expect(subject.started?).to be_falsey }
    end

    describe '#live?' do
      it {  expect(subject.live?).to be_falsey }
    end
  end

  context 'hangout_url is present and is not finished' do
    before do
      subject.hangout_url = 'test'
      subject.hoa_status = 'anything'
    end

    describe 'and the link is not older than 2 minutes and hoa_status' do
      before do
        allow(Time).to receive(:now).and_return(Time.mktime('10:01:59'))
      end
      describe '#live?' do
        it { expect(subject.live?).to be_truthy }
      end

      describe '#started?' do
        it { expect(subject.started?).to be_truthy }
      end
    end

    describe 'and the link is older than 2 minutes and hoa_status' do
      before do
        allow(Time).to receive(:now).and_return(Time.parse('10:02:01 UTC'))
      end
      describe '#live?' do
        it { expect(subject.live?).to be_falsey }
      end

      describe '#started?' do
        it { expect(subject.started?).to be_truthy }
      end
    end

    context 'url manually overridden' do
      before do
        subject.url_set_directly = true
        allow(subject.event).to receive(:current_start_time).and_return(Time.parse('10:00 UTC'))
        allow(subject.event).to receive(:current_end_time).and_return(Time.parse('10:30 UTC'))
      end

      it 'does not report live when link not updated' do
        allow(Time).to receive(:now).and_return(Time.parse('10:02 UTC'))
        allow(subject).to receive(:updated_at).and_return(Time.parse('9:30 UTC'))
        expect(subject.live?).to be_falsey
      end

      it 'report live when link is updated' do
        allow(Time).to receive(:now).and_return(Time.parse('10:02 UTC'))
        allow(subject).to receive(:updated_at).and_return(Time.parse('10:01 UTC'))
        expect(subject.live?).to be_truthy
      end

      it 'does not report live when event ends' do
        allow(Time).to receive(:now).and_return(Time.parse('10:31 UTC'))
        allow(subject).to receive(:updated_at).and_return(Time.parse('10:01 UTC'))
        expect(subject.live?).to be_falsey
      end

      it 'reports live when link is updated 10 min before start time' do
        allow(Time).to receive(:now).and_return(Time.parse('9:58 UTC'))
        allow(subject).to receive(:updated_at).and_return(Time.parse('09:51 UTC'))
        expect(subject.live?).to be_truthy
      end
    end
  end

  context 'hangout_url is present and hoa_status is finished' do
    before do
      subject.hangout_url = 'test'
      subject.hoa_status = 'finished'
    end

    it 'reports not live if the link is not older than 2 minutes' do
      allow(Time).to receive(:now).and_return(Time.mktime('10:01:59'))
      expect(subject.live?).to be_falsey
    end

    it 'reports not live if the link is older than 2 minutes' do
      allow(Time).to receive(:now).and_return(Time.parse('10:02:01 UTC'))
      expect(subject.live?).to be_falsey
    end
  end

  context 'associated hangout_participant_snapshots' do
    subject do
      create(:event_instance,
             updated: '10:00 UTC',
             hangout_url: nil,
             event: event,
             hangout_participants_snapshots_attributes: [{ participants: 'blah' }])
    end
    it 'should do stuff' do
      expect(subject.hangout_participants_snapshots.count).to eq 1
    end

    it 'should add more hangout snapshots when updated' do
      subject.update(hangout_participants_snapshots_attributes: [{ participants: 'stuff' }])
      expect(subject.hangout_participants_snapshots.count).to eq 2
    end
  end

  context '.yt_url' do
    it 'should return youtube link from youtube id' do
      subject.yt_video_id = 'mLBSQV-h-xo'
      expect(subject.yt_url).to eq 'https://youtu.be/mLBSQV-h-xo'
    end

    it 'should return nil if youtube id is nil' do
      subject.yt_video_id = nil
      expect(subject.yt_url).to eq nil
    end
  end

  context '#for' do
    it 'returns nil if event is nil' do
      subject.event = nil
      expect(subject.for).to eq nil
    end
  end
end
