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

    it 'calls tweet hangout notification' do
      expect(hangout).to receive(:tweet_hangout_notification)
      hangout.save
    end
  end

  context 'yt_video_id is present' do
    before { hangout.yt_video_id = 'YT123456' }

    it 'calls tweet_yt_link' do
      expect(hangout).to receive(:tweet_yt_link)
      hangout.save
    end

    it 'calls the TwitterService' do
      hangout.category = 'Scrum'

      expect(TwitterService).to receive(:tweet)
      hangout.save
    end

    context 'pair programming tweet' do
      before(:each) do
        hangout.category = 'PairProgramming'
        hangout.participants = {"0" => {"id" => "xxx.id.google.com^xxx", "hasMicrophone" => "true",
                                        "hasCamera" => "true", "hasAppEnabled" => "false",
                                        'isBroadcaster' => "false", "isInBroadcast" => "true",
                                        "displayIndex" => "0", "person" =>
                                            {"id" => "xxx", "displayName" => "Foo Bar",
                                             "image" => {"url" => ".../s96-c/photo.jpg"},
                                             "fa" => "false"}, "locale" => "en", "fa" => "false"},
                                "1" => {"id" => "xxx.id.google.com^xxx", "hasMicrophone" => "true",
                                        "hasCamera" => "true", "hasAppEnabled" => "false",
                                        "isBroadcaster" => "false", "isInBroadcast" => "true",
                                        "displayIndex" => "1", "person" =>
                                            {"id" => "xxx", "displayName" => "Bar Foo",
                                             "image" => {"url" => ".../s96-c/photo.jpg"},
                                             "fa" => "false"}, "locale" => "en", "fa" => "false"},
                                "2" => {"id" => "xxx.id.google.com^xxx", "hasMicrophone" => "true",
                                        "hasCamera" => "true", "hasAppEnabled" => "true",
                                        "isBroadcaster" => "true", "isInBroadcast" => "true",
                                        "displayIndex" => "2", "person" =>
                                            {"id" => "xxx", "displayName" => "John Doe",
                                             "image" => {"url" => ".../s96-c/photo.jpg"}, "fa" => "false"},
                                        "locale" => "en", "fa" => "false"}}
        @broadcaster = hangout.participants.each { |_, hash| break hash['person']['displayName'] if hash['isBroadcaster'] == 'true' }
      end
      it 'includes hosts name ' do
        expect(@broadcaster).to eq 'John Doe'
        expect(TwitterService).to receive(:tweet).with(/#{@broadcaster.split[0]}/) { :success }
        hangout.save
      end

      it 'includes Project title' do
        expect(TwitterService).to receive(:tweet).with(/#{hangout.project.title}/) { :success }
        hangout.save
      end
    end

  end

  context 'yt_video_id is NOT present' do
    before { hangout.yt_video_id = nil }

    it 'does not call TwitterService' do
      expect(TwitterService).to_not receive(:tweet)
      hangout.save
    end
  end

  context 'yt_video_id is an empty string' do
    before { hangout.yt_video_id = '' }

    it 'does not call TwitterService' do
      expect(TwitterService).to_not receive(:tweet)
      hangout.save
    end
  end

  context 'event category is recognized' do
    before do
      hangout.hangout_url = 'test'
    end

    it 'calls the TwitterService' do
      hangout.category = 'Scrum'

      expect(TwitterService).to receive(:tweet)
      hangout.save
    end

    it 'project title is included in a pair programming tweet' do
      hangout.category = 'PairProgramming'

      expect(TwitterService).to receive(:tweet).with(/#{hangout.project.title}/) { :success }
      hangout.save
    end
  end

  context 'event category is not recognized' do
    before do
      hangout.hangout_url = 'test'
    end

    it 'does not call TwitterService' do
      hangout.category = 'arbitrary-category'

      expect(TwitterService).to_not receive(:tweet)
      hangout.save
    end

    it 'raises an error' do
      hangout.category = 'arbitrary-category'

      expect(Rails.logger).to receive(:error)
      hangout.save
    end
  end

  context 'event_instance is changed' do
    before do
      @hangout_with_url = FactoryGirl.create(:event_instance,
                                             hangout_url: 'http://example.com')
    end

    let(:other_hangout) { @hangout_with_url }

    context 'hangout_url changes' do
      before { other_hangout.hangout_url = 'http://foo.example.com' }

      it 'calls tweet_hangout_notification again' do
        expect(other_hangout).to receive(:tweet_hangout_notification)
        other_hangout.save
      end
    end

    context 'hangout_url not changed' do
      before { other_hangout.title = 'changed' }

      it 'does not call tweet_hangout_notification' do
        expect(other_hangout).not_to receive(:tweet_hangout_notification)
        other_hangout.save
      end
    end
  end
end
