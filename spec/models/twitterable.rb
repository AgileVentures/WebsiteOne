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
      expect(@fake_model.is_valid_twitter_client?).to be_truthy
    end

    # we need to move this over to the event or event_instance models as this is not a cross-cutting concern
    it 'should tweet hangout notification' do
        expect(@fake_model).to respond_to(:tweet_hangout_notification)
    end

    # we need tests to cover this as should be a responsibility of the concern
    it "consumer key should be defined" do
        twitter_client = @fake_model.twitter_client
        expect(twitter_client.consumer_key).to_not be_nil
    end

end
