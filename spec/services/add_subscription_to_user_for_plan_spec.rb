# frozen_string_literal: true

describe AddSubscriptionToUserForPlan do
  subject(:add_subscription_to_user_for_plan) do
    described_class.with(user, sponsor, time, plan, payment_source, subscription_klass)
  end

  let(:subscription_klass) { class_double(Subscription) }

  let(:plan) { instance_double(Plan, name: 'Premium') }
  let(:third_party_id) { instance_double('ThirdPartyID') }
  let(:time) { instance_double(Time) }
  let(:user) { instance_double(User) }
  let(:sponsor) { instance_double(User) }
  let(:subscription) { instance_double(Subscription) }
  let(:existing_subscription1) { instance_double(Subscription) }
  let(:existing_subscription2) { instance_double(Subscription) }
  let(:payment_source) { instance_double(PaymentSource::Stripe) }

  before do
    allow(subscription_klass).to receive(:new)
    allow(user).to receive_message_chain(:subscriptions, :<<)
    allow(user).to receive(:save!)
    allow(user).to receive_message_chain(:title_list, :<<)
    allow(existing_subscription1).to receive_message_chain(:ended_at, :nil?).and_return(true)
    allow(existing_subscription2).to receive_message_chain(:ended_at, :nil?).and_return(false)
    allow(user).to receive(:subscriptions).and_return [existing_subscription1, existing_subscription2]
    allow(existing_subscription1).to receive(:ended_at=).with(time)
  end

  it 'creates a subscription of the appropriate type' do
    expect(subscription_klass).to receive(:new).with(started_at: time, sponsor: sponsor, plan: plan,
                                                     payment_source: payment_source)
    add_subscription_to_user_for_plan
  end

  it 'sets the user subscription' do
    expect(subscription_klass).to receive(:new).and_return(subscription)
    expect(user).to receive_message_chain(:subscriptions, :<<).with(subscription)
    add_subscription_to_user_for_plan
  end

  it 'adds Plan name to the user title list' do
    expect(user).to receive_message_chain(:title_list, :<<).with('Premium')
    add_subscription_to_user_for_plan
  end

  it 'saves the user' do
    expect(user).to receive(:save!)
    add_subscription_to_user_for_plan
  end

  it 'ensures all other existing subscriptions are ended' do
    expect(existing_subscription1).to receive(:ended_at=).with(time)
    add_subscription_to_user_for_plan
  end
end
