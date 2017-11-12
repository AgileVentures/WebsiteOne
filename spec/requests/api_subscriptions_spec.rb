require 'spec_helper'

describe "Subscriptions" do
  describe "GET /subscriptions" do
    let(:user) { FactoryGirl.create(:user, email: "kitty@cat.com") }
    let!(:subscription) { FactoryGirl.create(:subscription, user: user) }
    let(:headers) do
      {
       "ACCEPT" => "application/json",     # This is what Rails 4 accepts
       "HTTP_ACCEPT" => "application/json", # This is what Rails 3 accepts
       "Authorization: Token" => "token=TEST"
      }
    end

    it "succeeds" do
      get api_subscriptions_path, headers
      expect(response).to be_success
      expect(JSON.parse(response.body)).to include(a_hash_including("email"  => "kitty@cat.com"))
    end
  end
end
