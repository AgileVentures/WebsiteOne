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

    it 'tweets hangout notification' do
      expect(hangout).to receive(:generate_twitter_tweet)
      hangout.save
    end
  end

  context 'event_instance is changed' do
    before do
      @hangout_with_url = FactoryGirl.create(:event_instance, 
                                             hangout_url: 'http://example.com')
    end

    let(:other_hangout) { @hangout_with_url }
    it 'checks twitter client' do
      expect(other_hangout.can_tweet?).to be_truthy
    end

    context 'hangout_url changes' do
      before { other_hangout.hangout_url = 'http://foo.example.com' }
      it 'tweets again' do
        expect(other_hangout).to receive(:tweet_hangout_notification)
        other_hangout.save
      end
    end

    context 'hangout_url not changed' do
      before { other_hangout.title = 'changed' }
      it 'will trigger no tweet' do
        expect(other_hangout).not_to receive(:tweet_hangout_notification)
        other_hangout.save
      end
    end
  end
end
