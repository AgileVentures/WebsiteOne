require 'spec_helper'

describe PaypalService do
  subject(:paypal_service) { PaypalService.new }
  PREMIUM_PLAN_ID     = 'P-52R60478253699513THRRMAQ'
  PREMIUM_MOB_PLAN_ID = 'P-46V22764WE4158521THSKLJA'
  PREMIUM_F2F_PLAN_ID = 'P-171943672H2339648THSW3KQ'
  AUTH_TOKEN_RESPONSE = {
    :scope => "https://uri.paypal.com/services/subscriptions https://api.paypal.com/v1/payments/.* https://api.paypal.com/v1/vault/credit-card https://uri.paypal.com/services/applications/webhooks openid https://uri.paypal.com/payments/payouts https://api.paypal.com/v1/vault/credit-card/.*",
    :nonce => "2016-10-04T18:00:00ZP3PcGAv5XAncoc8Zt4MF5cRLlaEBW3OAoLEhMIFk--g",
    :access_token => "A101.tp_sF5GHqWnnqEQA13Ua5ABnIhRWgd-G9LhRnJdgOvJHc_L08zlfD9WgPF4I3kre.mShauuOGxWyw8ikViItmxkWmX78",
    :token_type => "Bearer",
    :app_id => "APP-80W284485P519543T",
    :expires_in => 30695
}
  before do 
    stub_request(:post, 'https://api.sandbox.paypal.com/v1/oauth2/token').to_return(body: AUTH_TOKEN_RESPONSE.to_json)
  end

  it 'creates a premium agreement' do
    agreement = paypal_service.create_agreement(PREMIUM_PLAN_ID)
    expect(agreement.name).to eq('Premium')
  end
  
  it 'creates a premium mob agreement' do
    agreement = paypal_service.create_agreement(PREMIUM_MOB_PLAN_ID)
    expect(agreement.name).to eq('Premium Mob')
  end
end
