require 'spec_helper'

describe Status do
  let(:user) { FactoryGirl.create(:user) }
  subject { FactoryGirl.create(:status, status: 'Spec by Rspec', user: user) }

  it { is_expected.to belong_to(:user)}
  it { is_expected.to validate_presence_of :status}
  it { is_expected.to validate_presence_of :user_id}


  it 'should have valid factory' do
    expect(FactoryGirl.create(:status)).to be_valid
  end

  it 'assigns user_id to status' do
    expect(subject[:user_id]).to eql(user.id)
  end

  it 'should be valid with all required attributes' do
    expect(subject).to be_valid
  end

  it 'should be invalid without status' do
    expect(build_stubbed :status, status: nil, user: user).to_not be_valid
  end

  it 'should be invalid without user_id' do
    expect(build_stubbed :status, user: nil).to_not be_valid
  end

end
