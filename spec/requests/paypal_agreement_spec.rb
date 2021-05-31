# frozen_string_literal: true

describe PaypalAgreementController, type: :request do
  describe 'POST /paypal/new' do
    let(:premium_plan) { FactoryBot.create(:plan, name: 'premium', paypal_id: 'P-6A8554404E294635VUDTNLWQ') }
    let(:redirect_url) do
      'https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=EC-8G803347TJ631023W'
    end
    let(:json_hash) { JSON.parse(File.read('spec/fixtures/paypal_agreement_response.json')) }
    let(:json_object) { JSON.parse(json_hash.to_json, object_class: OpenStruct) }
    let(:json_object_links) do
      json_object.body.links.map do |link|
        PayPalLinkMock.new link['method'], link.href
      end
    end
    let(:agreement) { double :agreement, error: nil, links: json_object_links }

    it 'redirects to a redirect url on successful agreement creation' do
      allow_any_instance_of(PaypalService).to receive(:create_agreement).and_return(agreement)
      post '/paypal/new', params: { plan: premium_plan.id }
      expect(response).to redirect_to(redirect_url)
    end
  end
end

class PayPalLinkMock
  attr_reader :method, :href

  def initialize(method, href)
    @method = method
    @href = href
  end
end
