require 'spec_helper'

describe AuthenticationsController do
  before(:all) do
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(:github, { uid: '123456' })
    @user = FactoryGirl.create(:user)
    @auth = @user.authentications.create(provider: 'github', uid: '123456')
  end

  let(:user) { @user }
  let(:auth) { @auth }

  context 'using Github authentication' do
    before(:all) do
      @request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:github]
    end

    it 'should work' do
      post :create

      current_user.should eq user
    end
  end
end
