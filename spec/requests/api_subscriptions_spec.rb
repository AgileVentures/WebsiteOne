require 'spec_helper'
require 'byebug'

describe Api::SubscriptionsController, type: :request do
  describe "GET /subscriptions" do
    let(:user) { FactoryBot.create(:user, email: "kitty@cat.com") }
    let(:start_time) { DateTime.new(2001, 2, 3, 4, 5, 6) }
    let(:end_time) { DateTime.new(2002, 2, 3, 4, 5, 6) }
    let(:start_date) { '2001-02-03' }
    let(:end_date) { '2002-02-03' }
    let(:plan) { FactoryBot.create(:plan, name: 'Premium') }
    let!(:subscription) { FactoryBot.create(:subscription, user: user, sponsor: user, plan: plan, started_at: start_time, ended_at: end_time) }
    let!(:payment_source) { FactoryBot.create(:paypal, subscription: subscription) }
    let(:credentials) { ActionController::HttpAuthentication::Token.encode_credentials('TEST') }
    let(:headers) do
      {
          "Authorization" => credentials,
          "Accept" => "application/json" # This is what Rails 4 accepts
          # "http_accept" => "application/json", # This is what Rails 3 accepts
      }
    end
    context 'with proper token' do
      it "succeeds", :show_in_doc do
        get api_subscriptions_path, params: {}, headers: headers
        expect(response).to be_success
        expect(JSON.parse(response.body)).to include(a_hash_including("payment_source" => "PaymentSource::PayPal", "plan_name" => plan.name, "email" => "kitty@cat.com", "sponsor_email" => "kitty@cat.com", "started_on" => start_date, "ended_on" => end_date))
      end

      context 'with nil ended_on' do
        let(:end_time) { nil }

        it 'succeeds' do
          get api_subscriptions_path, params: {}, headers: headers
          expect(response).to be_success
          expect(JSON.parse(response.body)).to include(a_hash_including("payment_source" => "PaymentSource::PayPal", "plan_name" => plan.name, "email" => "kitty@cat.com", "sponsor_email" => "kitty@cat.com", "started_on" => start_date, "ended_on" => nil))
        end
      end

      context 'with deleted user and sponsor' do
        let(:sponsor) { FactoryBot.create(:user, email: "catty@kit.com", deleted_at: 2.days.ago) }
        let!(:subscription) { FactoryBot.create(:subscription, user: user, sponsor: sponsor, plan: plan, started_at: start_time, ended_at: end_time) }

        it 'succeeds' do
          user.destroy
          get api_subscriptions_path, params: {}, headers: headers
          expect(response).to be_success
          expect(JSON.parse(response.body)).to include(a_hash_including("payment_source" => "PaymentSource::PayPal", "plan_name" => plan.name, "email" => "kitty@cat.com", "sponsor_email" => "catty@kit.com", "started_on" => start_date, "ended_on" => end_date))
        end

      end
    end

    context 'without proper token' do
      let(:credentials) { ActionController::HttpAuthentication::Token.encode_credentials('wrongtoken') }

      it "fails", :show_in_doc do
        get api_subscriptions_path, params: {}, headers: headers
        expect(response).not_to be_success
      end
    end
  end
end
