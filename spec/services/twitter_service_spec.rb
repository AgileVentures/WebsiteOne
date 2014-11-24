require 'spec_helper'
require 'twitter_service'

describe 'TwitterService' do
    before :each do
      Settings.features.twitter.notifications.enabled = true
      stub_request(:post, /api\.twitter\.com/).to_return(:status => 200, :body => '{ "id": 243145735212777472, "text": "hello world" }')
    end

    context "with tweet notification setting" do
      describe "enabled" do
        it "allows the tweet" do
          expect(Twitterable.tweet('this should tweet')).to be_truthy
        end

        it "creates a valid twitter client object" do
          expect(Twitterable.twitter_client.kind_of?(Twitter::REST::Client)).to eq true
        end

        it "consumer key should be defined" do
          twitter_client = Twitterable.twitter_client

          expect(twitter_client.consumer_key).to_not be_nil
          expect(twitter_client.consumer_secret).to_not be_nil
          expect(twitter_client.access_token).to_not be_nil
          expect(twitter_client.access_token_secret).to_not be_nil
        end

        it 'sends a post request to the twitter api' do
          response = Twitterable.tweet('hello world')

          assert_requested(:post, /api\.twitter\.com/) do |req|
            expect(response).to eq true
          end
        end
      end

      describe "disabled" do
        it "does not allow the tweet" do
          Settings.features.twitter.notifications.enabled = false
          expect(Twitterable.tweet('this should not tweet')).to eq false
        end
      end
    end
end
