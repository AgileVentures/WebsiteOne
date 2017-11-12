require 'spec_helper'

describe "Subscriptions" do
  describe "GET /subscriptions" do
    let(:user) { FactoryGirl.create(:user, email: "kitty@cat.com") }
    let!(:subscription) { FactoryGirl.create(:subscription, user: user) }
    let(:headers) do
      {
       "Authorization" => "Token token=TEST",
       "Accept" => "application/json"     # This is what Rails 4 accepts
       # "http_accept" => "application/json", # This is what Rails 3 accepts
      }
    end

    it "succeeds" do
      get api_subscriptions_path, header: headers
      expect(response).to be_success
      expect(JSON.parse(response.body)).to include(a_hash_including("email"  => "kitty@cat.com"))
    end
  end
end
