require 'spec_helper'

describe PaypalAgreementController, type: :request do
  describe 'POST /paypal/new' do
    let(:premium_plan) { FactoryBot.create(:plan, name:'premium', paypal_id: 'P-6A8554404E294635VUDTNLWQ') }
    let(:redirect_url) { 'https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=EC-87855937UN570910D' }
    let(:agreement) { File.read('spec/fixtures/paypal_agreement_response.json')  }

    it 'redirects to a redirect url on successful agreement creation' do
      allow_any_instance_of(PaypalService).to receive(:create_agreement).with(premium_plan.paypal_id).and_return(agreement)
      post '/paypal/new', params: { plan: premium_plan.id }
      expect(response).to redirect_to(redirect_url)
    end    
  end 
end