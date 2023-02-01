# frozen_string_literal: true

describe Authentication, type: :model do
  let(:user) { create(:user) }
  let!(:auth) { user.authentications.create!(provider: 'github', uid: '12345') }
  before do
    @user = user
    # @auth = auth
  end

  it 'must have an associated user' do
    auth.user_id = nil
    expect { auth.save! }.to raise_error ActiveRecord::RecordInvalid
  end

  it 'must have an associated provider' do
    auth.provider = nil
    expect(auth).to_not be_valid
  end

  it 'must have an associated UID' do
    auth.uid = nil
    expect(auth).to_not be_valid
  end

  it 'must have a unique user-provider combination' do
    failed_auth = user.authentications.build(provider: 'github', uid: '098766')
    expect(failed_auth).to_not be_valid
  end
end
