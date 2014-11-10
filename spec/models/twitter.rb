require 'spec_helper'
require 'Twitter'

describe 'TwitterConcern' do
    before :all do
      class FakeModel
        include ActiveModel::Model
        include Twitter
      end
      @fake_model = FakeModel.new
    end

    it "should create a twitter client object" do
        expect(@fake_model).to respond_to(:create_twitter_client)
        expect(@fake_model.create_twitter_client).to be_a(Twitter::REST::Client)
    end

    it "consumer key should be defined" do
        twitter_client = @fake_model.create_twitter_client

        expect(twitter_client.consumer_key).to eq('kdshflkdskflh')
    end

    # test ability of concern to do posts.
      # stub api
end