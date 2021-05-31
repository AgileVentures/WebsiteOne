# frozen_string_literal: true

describe Status do
  let(:user) { FactoryBot.create(:user) }
  subject { FactoryBot.create(:status, user: user) }

  it { is_expected.to belong_to(:user).counter_cache(:status_count) }
  it { is_expected.to validate_presence_of :status }
  it { is_expected.to validate_presence_of :user_id }

  it 'should have valid factory' do
    expect(FactoryBot.create(:status)).to be_valid
  end

  it 'assigns user_id to status' do
    expect(subject[:user_id]).to eql(user.id)
  end

  it 'should be valid with all required attributes' do
    expect(subject).to be_valid
  end

  it 'should be invalid without status' do
    expect(build_stubbed(:status, status: nil, user: user)).to_not be_valid
  end

  it 'should be invalid without user_id' do
    expect(build_stubbed(:status, user: nil)).to_not be_valid
  end

  it 'should be invalid with unpredicted content' do
    expect(build_stubbed(:status, status: 'wtf?')).to_not be_valid
  end
end
