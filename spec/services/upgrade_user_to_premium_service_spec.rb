require 'spec_helper'

describe UpgradeUserToPremium do

  subject(:upgrade_user_to_premium) { described_class.with(user, time, stripe_id, payment_source_klass, subscription_klass) }

  let(:subscription_klass) { class_double(Premium) }
  let(:payment_source_klass) { class_double(PaymentSource::Stripe) }

  let(:stripe_id) { instance_double('StripeID') }
  let(:time) { instance_double(Time) }
  let(:user) { instance_double(User) }
  let(:subscription) { instance_double(Premium) }
  let(:payment_source) { instance_double(PaymentSource::Stripe) }

  before do
    allow(payment_source_klass).to receive(:new)
    allow(subscription_klass).to receive(:new)
    allow(user).to receive(:subscription=)
    allow(user).to receive(:save)
    allow(user).to receive_message_chain(:title_list, :<<)
  end

  it 'creates a payment source' do
    expect(payment_source_klass).to receive(:new).with({identifier: stripe_id})
    upgrade_user_to_premium
  end

  it 'creates a subscription of the appropriate type' do
    allow(payment_source_klass).to receive(:new).and_return(payment_source)
    expect(subscription_klass).to receive(:new).with(started_at: time, payment_source: payment_source)
    upgrade_user_to_premium
  end

  it 'sets the user subscription' do
    expect(subscription_klass).to receive(:new).and_return(subscription)
    expect(user).to receive(:subscription=).with(subscription)
    upgrade_user_to_premium
  end

  it 'adds Premium to the user title list' do
    expect(user).to receive_message_chain(:title_list, :<<).with('Premium')
    upgrade_user_to_premium
  end

  it 'saves the user' do
    expect(user).to receive(:save)
    upgrade_user_to_premium
  end
end