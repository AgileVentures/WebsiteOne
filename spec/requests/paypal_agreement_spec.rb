require 'spec_helper'

describe PaypalAgreementController, type: :request do
  describe 'POST /paypal/new' do
    # let(:paypal_service) { instance_double(PaypalService) }
    let(:premium_plan) { FactoryBot.create(:plan, name:'premium', paypal_id: 'P-6A8554404E294635VUDTNLWQ') }
    let(:redirect_url) { 'https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=EC-87855937UN570910D' }
    let(:agreement) { { links: [{ "href": "https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=EC-87855937UN570910D",
                                  "rel": "approval_url", "method": "REDIRECT"
                                },
                                { "href": "https://api.sandbox.paypal.com/v1/payments/billing-agreements/EC-87855937UN570910D/agreement-execute", 
                                  "rel": "execute",
                                  "method": "POST"
                                }]
                      } 
                    }
   
    it 'posts to the api without crashing' do
      # paypal_service.stub(:create_agreement) { agreement }
      paypal_service = instance_double(PaypalService)
      allow(paypal_service).to receive(:create_agreement).and_return(agreement)
      post '/paypal/new', params: { plan: premium_plan.id }
      expect(response).to redirect_to(redirect_url)
    end    
  end 
end