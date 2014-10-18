require 'spec_helper'
require 'twitterable'

describe 'TwitterConcern' do
    before :all do
      class FakeModel
        include ActiveModel::Model
        include Twitterable
      end
      @fake_model = FakeModel.new
    end

    it "should create a twitter client object" do
        expect(@fake_model).to respond_to(:tweet_hangout_notification)
        #expect(@fake_model.create_twitter_client).to be_a(Twitter::REST::Client)
    end

    # ripped it bcause twitter client is not exposed anymore
    #it "consumer key should be defined" do
    #    twitter_client = @fake_model.create_twitter_client
    #
    #    expect(twitter_client.consumer_key).to eq('kdshflkdskflh')
    #end

    # test ability of concern to do posts.
      # stub api
end
