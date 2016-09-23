require 'spec_helper'

shared_examples 'a subscription' do
  it { should belong_to :user }

  it 'has the correct type' do
    expect(subject.type).to eq type
  end
end

describe Subscription, type: :model do
  let(:type) { nil }
  it_behaves_like 'a subscription'
end

describe Premium, type: :model do
  let(:type) { 'Premium' }
  it_behaves_like 'a subscription'
end

describe PremiumPlus, type: :model do
  let(:type) { 'PremiumPlus' }
  it_behaves_like 'a subscription'
end
