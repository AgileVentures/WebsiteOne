require 'spec_helper'

describe AddSubscriptionToUserForPlan do

  subject(:add_subscription_to_user_for_plan) { described_class.with(user, time, third_party_id, plan, payment_source_klass, subscription_klass) }

  let(:subscription_klass) { class_double(Subscription) }
  let(:payment_source_klass) { class_double(PaymentSource::Stripe) }

  let(:plan) { instance_double(Plan, name: 'Premium') }
  let(:third_party_id) { instance_double('ThirdPartyID') }
  let(:time) { instance_double(Time) }
  let(:user) { instance_double(User) }
  let(:subscription) { instance_double(Subscription) }
  let(:payment_source) { instance_double(PaymentSource::Stripe) }

  before do
    allow(payment_source_klass).to receive(:new)
    allow(subscription_klass).to receive(:new)
    allow(user).to receive(:subscription=)
    allow(user).to receive(:save)
    allow(user).to receive_message_chain(:title_list, :<<)
  end

  it 'creates a payment source' do
    expect(payment_source_klass).to receive(:new).with({identifier: third_party_id})
    add_subscription_to_user_for_plan
  end

  it 'creates a subscription of the appropriate type' do
    allow(payment_source_klass).to receive(:new).and_return(payment_source)
    expect(subscription_klass).to receive(:new).with(started_at: time, plan: plan, payment_source: payment_source)
    add_subscription_to_user_for_plan
  end

  it 'sets the user subscription' do
    expect(subscription_klass).to receive(:new).and_return(subscription)
    expect(user).to receive(:subscription=).with(subscription)
    add_subscription_to_user_for_plan
  end

  it 'adds Plan name to the user title list' do
    expect(user).to receive_message_chain(:title_list, :<<).with('Premium')
    add_subscription_to_user_for_plan
  end

  it 'saves the user' do
    expect(user).to receive(:save)
    add_subscription_to_user_for_plan
  end
end