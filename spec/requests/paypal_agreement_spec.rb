require 'spec_helper'

describe PaypalAgreementController, type: :request do
  describe 'POST /paypal/new' do
    subject { PaypalService.new }
    # let(:paypal_service) { instance_double(PaypalService) }
    let(:premium_plan) { FactoryBot.create(:plan, name:'premium', paypal_id: 'P-6A8554404E294635VUDTNLWQ') }
    let(:redirect_url) { 'https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=EC-87855937UN570910D' }
    let(:agreement) { 
                      {
                        body: '{ 
                          "links": [{ 
                                    "href": "https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=EC-87855937UN570910D",
                                    "rel": "approval_url", "method": "REDIRECT"
                                  },
                                  { 
                                    "href": "https://api.sandbox.paypal.com/v1/payments/billing-agreements/EC-87855937UN570910D/agreement-execute", 
                                    "rel": "execute",
                                    "method": "POST"
                                  }]
                        }' 
                      }
                    }
   
    it 'posts to the api without crashing' do
      # paypal_service = object_double(PaypalService.new)
      paypal_service = double(PaypalService.new)
      allow(paypal_service).to receive(:create_agreement).with(premium_plan.paypal_id).and_return(agreement)
      
      post '/paypal/new', params: { plan: premium_plan.id }
      expect(paypal_service).to have_received(:create_agreement).with(premium_plan.paypal_id)
      expect(response).to redirect_to(redirect_url)
    end    
  end 
end