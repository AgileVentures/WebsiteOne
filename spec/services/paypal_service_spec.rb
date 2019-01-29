require 'spec_helper'

describe PaypalService do
  PREMIUM_PLAN_ID     = 'P-52R60478253699513THRRMAQ'
  PREMIUM_MOB_PLAN_ID = 'P-46V22764WE4158521THSKLJA'
  PREMIUM_F2F_PLAN_ID = 'P-171943672H2339648THSW3KQ'

  it 'creates a premium agreement' do
    agreement = PaypalService.new.create_agreement(PREMIUM_PLAN_ID)
    expect(agreement.name).to eq('Premium')
  end

  it 'creates a premium mob agreement' do
    agreement = PaypalService.new.create_agreement(PREMIUM_MOB_PLAN_ID)
    expect(agreement.name).to eq('Premium Mob')
  end
end