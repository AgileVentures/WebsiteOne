require 'spec_helper'
require 'twitterable'

describe 'TwitterConcern' do
    before :all do
      # FIXME make better use of the settings
      Features.twitter.hangout_notifications.enabled = true

      # TODO most Twitterable methods are now class methods. Does it still make sense to test the 'mixin' functionality?
      class FakeModel
        include ActiveModel::Model
        include Twitterable
      end
      @fake_model = FakeModel.new
    end

    it "should create a twitter client object" do
      expect(Twitterable.can_tweet?).to be_truthy
    end

    it "consumer key should be defined" do
        twitter_client = Twitterable.twitter_client
        expect(twitter_client.consumer_key).to_not be_nil
    end

    it 'sends a post request to the twitter api' do
      stub_request(:post, /api\.twitter\.com/).to_return(:status => 200, :body => '{ "id": 243145735212777472, "text": "hello world" }')

      response = Twitterable.tweet('hello world')

      assert_requested(:post, /api\.twitter\.com/) do |req|
        expect(response).to eq true
      end
    end

    after :all do
      Object.send(:remove_const, :FakeModel)
      Features.twitter.hangout_notifications.enabled = false
    end
end
