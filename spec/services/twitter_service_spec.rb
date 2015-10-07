require 'spec_helper'
require 'twitter_service'

describe 'TwitterService' do
    before :each do
      Settings.features.twitter.notifications.enabled = true
      stub_request(:post, /api\.twitter\.com/).to_return(:status => 200, :body => '{ "id": 243145735212777472, "text": "hello world" }')
    end

    let(:hangout) { FactoryGirl.create(:event_instance, updated: '10:00 UTC', hangout_url: nil, yt_video_id: nil) }
    let(:hangout_participants) do
        {"0" => {"id" => "xxx.id.google.com^xxx", "hasMicrophone" => "true",
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

    end

    context 'pair programming tweet' do
      before(:each) do
        hangout.category = 'PairProgramming'
        hangout.participants = hangout_participants
      end

      context 'with project' do
        it 'posts twitter notification with project title' do
          hangout.hangout_url = 'new_hangout_url'
          expect(TwitterService).to receive(:tweet).with(/#{hangout.project.title} #{hangout.hangout_url}/) { :success }
          TwitterService.tweet_hangout_notification(hangout)
        end

        it 'tweets video link with project title' do
          hangout.yt_video_id = 'new_video_id'
          expect(TwitterService).to receive(:tweet).with("#{hangout.broadcaster.split[0]} just finished #PairProgramming on #{hangout.project.title} You can catch the recording at youtu.be/#{hangout.yt_video_id} #CodeForGood #pairwithme") { :success }
          TwitterService.tweet_yt_link(hangout)
        end
      end

      context 'without project' do
        before(:each) { hangout.project = nil }

        it 'posts twitter notification with hangout title' do
          hangout.hangout_url = 'new_hangout_url'
          expect(TwitterService).to receive(:tweet).with(/#{hangout.title} #{hangout.hangout_url}/) { :success }
          TwitterService.tweet_hangout_notification(hangout)
        end

        it 'tweets video link with hangout title' do
          hangout.yt_video_id = 'new_video_id'
          expect(TwitterService).to receive(:tweet).with("#{hangout.broadcaster.split[0]} just finished #PairProgramming on #{hangout.title} You can catch the recording at youtu.be/#{hangout.yt_video_id} #CodeForGood #pairwithme") { :success }
          TwitterService.tweet_yt_link(hangout)
        end
      end
    end

    context 'scrum notification' do
      before(:each) do
        hangout.category = 'Scrum'
        hangout.participants = hangout_participants
      end

      it 'posts twitter notification' do
        hangout.hangout_url = 'new_hangout_url'
        expect(TwitterService).to receive(:tweet).with(/#{hangout.hangout_url}/) { :success }
        TwitterService.tweet_hangout_notification(hangout)
      end

      it 'tweets video link' do
        hangout.yt_video_id = 'new_video_id'
        expect(TwitterService).to receive(:tweet).with("#{hangout.broadcaster.split[0]} just hosted an online #scrum using #googlehangouts Missed it? Catch the recording at youtu.be/#{hangout.yt_video_id} #CodeForGood #opensource") { :success }
        TwitterService.tweet_yt_link(hangout)
      end
    end

    it 'does not tweet and raises error when category is unrecognized' do
      hangout.hangout_url = 'new_url'
      hangout.category = 'unrecognized'

      expect(TwitterService).to_not receive(:tweet)
      expect(Rails.logger).to receive(:error)

      TwitterService.tweet_hangout_notification(hangout)
    end

    context "with tweet notification setting" do
      describe "enabled" do
        it "allows the tweet" do
          expect(TwitterService.tweet('this should tweet')).to be_truthy
        end

      end
      describe "disabled" do
        it "does not allow the tweet" do
          Settings.features.twitter.notifications.enabled = false
          expect(TwitterService.tweet('this should not tweet')).to eq false
        end
      end
    end

    it "creates a valid twitter client object" do
      expect(TwitterService.twitter_client.kind_of?(Twitter::REST::Client)).to eq true
    end

    it "configures the client object" do
      twitter_client = TwitterService.twitter_client

      expect(twitter_client.consumer_key).to_not be_nil
      expect(twitter_client.consumer_secret).to_not be_nil
      expect(twitter_client.access_token).to_not be_nil
      expect(twitter_client.access_token_secret).to_not be_nil
    end

    it 'sends a post request to the twitter api' do
      response = TwitterService.tweet('hello world')

      assert_requested(:post, /api\.twitter\.com/) do |req|
        expect(response).to eq true
      end
    end
end
