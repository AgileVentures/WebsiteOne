require 'spec_helper'
require 'twitterable'

describe 'TwitterConcern' do

    before :all do
      Features.twitter.hangout_notifications.enabled = true
      class FakeModel
        include ActiveModel::Model
        include Twitterable
      end
      @fake_model = FakeModel.new
    end

    it "should create a twitter client object" do
      expect(@fake_model.can_tweet?).to be_truthy
    end

    it "consumer key should be defined" do
        twitter_client = @fake_model.twitter_client
        expect(twitter_client.consumer_key).to_not be_nil
    end

    it 'sends a post request to the twitter api' do
      stub_request(:post, /api\.twitter\.com/).to_return(:status => 200, :body => '{ "id": 243145735212777472, "text": "hello world" }')

      response = @fake_model.tweet('hello world')

      assert_requested(:post, /api\.twitter\.com/) do |req|
        # it will be a problem for future testing that our tweet method only returns true on success
        # for example, we can't check that the response contains 'hello world' ~cm
        expect(response).to eq true 
      end
    end

    after :all do
      Object.send(:remove_const, :FakeModel)
      Features.twitter.hangout_notifications.enabled = false
    end
end
