# frozen_string_literal: true

shared_examples 'a subscription' do
  it { should belong_to :user }
  it { should belong_to :plan }

  it { should have_one :payment_source }

  it 'has the correct type' do
    expect(subject.type).to eq type
  end

  it { should validate_presence_of :started_at }

  it 'has ended_at' do
    expect(subject.ended_at).to be_nil
  end

  it { should delegate_method(:identifier).to(:payment_source) }
end

describe Subscription, type: :model do
  let(:type) { nil }
  it_behaves_like 'a subscription'
end

describe Premium, type: :model do
  let(:type) { 'Premium' }
  it_behaves_like 'a subscription'
end

describe PremiumMob, type: :model do
  let(:type) { 'PremiumMob' }
  it_behaves_like 'a subscription'
end

describe PremiumF2F, type: :model do
  let(:type) { 'PremiumF2F' }
  it_behaves_like 'a subscription'
end

describe PremiumPlus, type: :model do
  let(:type) { 'PremiumPlus' }
  it_behaves_like 'a subscription'
end
