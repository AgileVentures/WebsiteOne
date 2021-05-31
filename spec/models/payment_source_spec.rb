# frozen_string_literal: true

shared_examples 'a payment source' do
  it { should belong_to :subscription }
  it 'has the correct type' do
    expect(subject.type).to eq type
  end

  it 'has identifier' do
    expect(subject.identifier).to be_nil
  end
end

describe PaymentSource::PaymentSource do
  let(:type) { nil }
  it_behaves_like 'a payment source'
end

describe PaymentSource::CraftAcademy do
  let(:type) { 'PaymentSource::CraftAcademy' }
  it_behaves_like 'a payment source'
end

describe PaymentSource::Stripe do
  let(:type) { 'PaymentSource::Stripe' }
  it_behaves_like 'a payment source'
end

describe PaymentSource::Invoice do
  let(:type) { 'PaymentSource::Invoice' }
  it_behaves_like 'a payment source'
end

describe PaymentSource::Other do
  let(:type) { 'PaymentSource::Other' }
  it_behaves_like 'a payment source'
end
