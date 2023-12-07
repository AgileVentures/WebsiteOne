require 'spec_helper'

describe PayPal::SDK::Core::API::REST do

  module PayPalRest
    class API < PayPal::SDK::Core::API::REST
    end
  end

  def create_api(*args)
    api = PayPalRest::API.new(*args)
    @log_file ||= File.open("spec/log/rest_http.log", "w")
    api.http.set_debug_output(@log_file)
    api
  end

  before :all do
    @api = create_api("v1/payments/", :with_authentication)
    @vault_api = create_api("v1/vault/", :with_authentication)
  end

  describe "Configuration" do
    it "create api with prefix" do
      api = create_api("v1/payments")
      expect(api.uri.path).to eql "/v1/payments"
    end

    it "service endpoint for sandbox" do
      api = create_api
      expect(api.service_endpoint).to eql "https://api.sandbox.paypal.com"
      expect(api.token_endpoint).to   eql "https://api.sandbox.paypal.com"
      api = create_api( :mode => "sandbox" )
      expect(api.service_endpoint).to eql "https://api.sandbox.paypal.com"
      expect(api.token_endpoint).to   eql "https://api.sandbox.paypal.com"
      api = create_api( :mode => :sandbox )
      expect(api.service_endpoint).to eql "https://api.sandbox.paypal.com"
      expect(api.token_endpoint).to   eql "https://api.sandbox.paypal.com"
      api = create_api( :mode => "invalid" )
      expect(api.service_endpoint).to eql "https://api.sandbox.paypal.com"
      expect(api.token_endpoint).to   eql "https://api.sandbox.paypal.com"
      api = create_api( :mode => nil )
      expect(api.service_endpoint).to eql "https://api.sandbox.paypal.com"
      expect(api.token_endpoint).to   eql "https://api.sandbox.paypal.com"
    end

    it "service endpoint for live" do
      api = create_api( :mode => "live" )
      expect(api.service_endpoint).to eql "https://api.paypal.com"
      expect(api.token_endpoint).to   eql "https://api.paypal.com"
      api = create_api( :mode => :live )
      expect(api.service_endpoint).to eql "https://api.paypal.com"
      expect(api.token_endpoint).to   eql "https://api.paypal.com"
    end

    it "override service endpoint" do
      api = create_api( :rest_endpoint => "https://testing.api.paypal.com" )
      expect(api.service_endpoint).to eql "https://testing.api.paypal.com"
      expect(api.token_endpoint).to   eql "https://testing.api.paypal.com"
      api = create_api( :endpoint => "https://testing.api.paypal.com" )
      expect(api.service_endpoint).to eql "https://testing.api.paypal.com"
      expect(api.token_endpoint).to   eql "https://testing.api.paypal.com"
    end

    it "override token endpoint" do
      api = create_api( :rest_token_endpoint => "https://testing.api.paypal.com" )
      expect(api.service_endpoint).to eql "https://api.sandbox.paypal.com"
      expect(api.token_endpoint).to   eql "https://testing.api.paypal.com"
    end
  end

  describe "Validation" do
    it "Invalid client_id and client_secret" do
      api = create_api(:with_authentication, :client_id => "XYZ", :client_secret => "ABC")
      expect {
        api.token
      }.to raise_error PayPal::SDK::Core::Exceptions::UnauthorizedAccess
    end

    it "Should handle expired token" do
      old_token = @api.token
      @api.token_hash[:expires_in] = 0
      new_token = @api.token
      expect(@api.token_hash[:expires_in]).not_to eql 0
    end

    it "Get token" do
      expect(@api.token).not_to be_nil
    end
  end

  describe "Success request", :integration => true do

    it "Create Payment" do
      response = @api.post("payment", {
        "intent" => "sale",
        "payer" => {
          "payment_method" => "credit_card",
          "funding_instruments" => [{
            "credit_card" => {
              "type" => "visa",
              "number" => "4567516310777851",
              "expire_month" => "11", "expire_year" => "2018",
              "first_name" => "Joe", "last_name" => "Shopper" }}]},
        "transactions" => [{
          "amount" => {
            "total" => "7.47",
            "currency" => "USD" }}]})
      expect(response["error"]).to be_nil
    end

    it "List Payments" do
      response = @api.get("payment", { "count" => 10 })
      expect(response["error"]).to be_nil
      expect(response["count"]).not_to be_nil
    end

    it "Execute Payment"

    it "Create FundingInstrument" do
      new_funding_instrument = @vault_api.post("credit-card", {
        "type" =>  "visa",
        "number" =>  "4111111111111111",
        "expire_month" =>  "11", "expire_year" =>  "2018",
        "cvv2" =>  "874",
        "first_name" =>  "Joe", "last_name" =>  "Shopper" })
      expect(new_funding_instrument["error"]).to  be_nil
      expect(new_funding_instrument["id"]).not_to be_nil

      funding_instrument = @vault_api.get("credit-card/#{new_funding_instrument["id"]}")
      expect(funding_instrument["error"]).to be_nil
      expect(funding_instrument["id"]).to eql new_funding_instrument["id"]
    end

  end

  describe "Failure request", :integration => true do
    it "Invalid Resource ID" do
      expect {
        response = @api.get("payment/PAY-1234")
      }.to raise_error PayPal::SDK::Core::Exceptions::ResourceNotFound
    end

    it "Invalid parameters" do
      response = @api.post("payment")
      expect(response["error"]["name"]).to eql "VALIDATION_ERROR"
    end
  end

  describe "format response" do
    before :each do
      @response = instance_double(Net::HTTPResponse)
      allow(@response).to receive(:code) { "200" }
      allow(@response).to receive(:content_type) { "application/json" }
    end

    it "parses empty object JSON correctly" do
      allow(@response).to receive(:body) { "{}" }
      payload = {
        :response => @response
      }

      formatted_response = @api.format_response(payload)
      expect(formatted_response).to_not be_nil
      expect(formatted_response[:data]).to eq({})
    end

    it "parses empty string JSON correctly" do
      allow(@response).to receive(:body) { '""' }
      payload = {
        :response => @response
      }

      formatted_response = @api.format_response(payload)
      expect(formatted_response).to_not be_nil
      expect(formatted_response[:data]).to eq("")
    end

    it "parses whitespace body correctly" do
      allow(@response).to receive(:body) { ' 	 ' }
      payload = {
        :response => @response
      }

      formatted_response = @api.format_response(payload)
      expect(formatted_response).to_not be_nil
      expect(formatted_response[:data]).to eq({})
    end

    it "parses nil body correctly" do
      allow(@response).to receive(:body) { nil }
      payload = {
        :response => @response
      }

      formatted_response = @api.format_response(payload)
      expect(formatted_response).to_not be_nil
      expect(formatted_response[:data]).to eq({})
    end

    it "parses with whitespace around JSON correctly" do
      allow(@response).to receive(:body) { '    { "test": "value"  } ' }
      payload = {
        :response => @response
      }

      formatted_response = @api.format_response(payload)
      expect(formatted_response).to_not be_nil
      expect(formatted_response[:data]).to eq({ "test" => "value" })
    end
  end
end
