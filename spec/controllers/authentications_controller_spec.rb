require 'spec_helper'

describe AuthenticationsController do

  before(:each) do
    OmniAuth.config.mock_auth[:agileventures] = {
        'provider' => :agileventures,
        'uid' => '12345678',
        'info' => { 'email' => 'foo@agileventures.org' }
    }
    @provider = :agileventures
  end

  it 'should render a failure message on unsuccessful authentication' do
    get :failure
    expect(flash[:alert]).to eq 'Authentication failed.'
    expect(response).to redirect_to root_path
  end

  context 'destroying authentications' do
    before(:each) do
      @user = double(User, id: 1, friendly_id: 'my-id', encrypted_password: 'i-am-encrypted')
      request.env['warden'].stub :authenticate! => @user
      controller.stub :current_user => @user

      @auth = double(Authentication)
      @auths = [@auth]
      @user.should_receive(:authentications).at_least(1).and_return @auths
      @auths.should_receive(:find).and_return @auth
    end

    it 'should be removable for users with a password' do
      @auths.should_receive(:count).and_return 2
      @auth.should_receive(:destroy).and_return true
      get :destroy, id: 1
      expect(flash[:notice]).to eq 'Successfully removed profile.'
    end

    it 'should not be allowed for users without any other means of authentication' do
      @auths.should_receive(:count).and_return 1
      @user.should_receive(:encrypted_password).and_return nil
      controller.should_receive(:authenticate_user!).and_return true
      get :destroy, id: 1
      expect(flash[:alert]).to eq 'Bad idea!'
    end
  end

  before(:each) do
    request.env['omniauth.auth'] = OmniAuth.config.mock_auth[@provider]
    request.env['omniauth.params'] = {}
  end

  context 'for unregistered users' do

    before(:each) do
    end
  end

  context 'for not signed in users' do

    before(:each) do
      Authentication.should_receive(:find_by_provider_and_uid).and_return nil
      @user = double(User)
      @user.stub(:apply_omniauth)
    end

    it 'should work with valid credentials' do
      User.should_receive(:new).and_return(@user)
      @user.should_receive(:save).and_return(true)
      get :create, provider: @provider
      expect(flash[:notice]).to eq 'Signed in successfully.'
    end

    it 'should sign in the correct user' do
      Authentication.should_receive(:find_by_provider_and_uid).and_return @auth
      controller.should_receive(:sign_in_and_redirect)
      @auth.should_receive(:user).at_least(1).and_return @user
      get :create, provider: @provider
      expect(flash[:notice]).to eq 'Signed in successfully.'
    end
  end

  context 'for signed in users' do

    before(:each) do
      @user = double(User, id: 1, friendly_id: 'my-id', encrypted_password: 'i-am-encrypted')
      request.env['warden'].stub :authenticate! => @user
      controller.stub :current_user => @user
      @auth = double(Authentication, user: @user)
      controller.stub :user_signed_in? => true
    end

    it 'should not allow connecting to a profile when the profile already exists under a different user' do
      Authentication.stub(:find_by_provider_and_uid).and_return @auth
      other_user = double(User, id: @user.id + 1)
      controller.stub :current_user => other_user
      get :create, provider: @provider
      expect(flash[:alert]).to eq 'Another account is already associated with these credentials!'
      expect(response).to redirect_to root_path
    end

    context 'connecting to a new profile' do

      before(:each) do
        Authentication.stub(:find_by_provider_and_uid).and_return nil
        @user.stub_chain(:authentications, :build).and_return @auth
      end

      it 'should be able to create other profiles' do
        other_auths = %w( Glitter Smoogle HitPub )
        other_auths.each do |p|
          @auth.should_receive(:save).and_return true
          get :create, provider: p
          expect(flash[:notice]).to eq 'Authentication successful.'
        end
      end

      it 'should not accept multiple profiles from the same source' do
        @auth.should_receive(:save).and_return false
        get :create, provider: @provider
        expect(flash[:alert]).to eq 'Unable to create additional profiles.'
      end
    end
  end

  describe 'youtube authentication'
  before(:each) do
    controller.stub(authenticate_user!: true)

    request.env['omniauth.auth'] = {}
    request.env['omniauth.auth']['credentials'] = {}

    request.env['omniauth.params'] = {}
    request.env['omniauth.params']['youtube'] = true

    request.env['omniauth.origin'] = 'back_path'
  end

  it 'calls #link_to_youtube' do
    expect(controller).to receive(:link_to_youtube)
    get :create, provider: 'github'
  end
  it '#link_to_youtube: gets channel_id if user is authenticated and does not have youtube_id' do
    request.env['omniauth.auth']['credentials']['token'] = 'token'
    controller.stub(current_user: double(User, youtube_id: nil))

    expect(Youtube).to receive(:channel_id)
    get :create, provider: 'github'
  end

  it '#link_to_youtube: redirects back' do
    get :create, provider: 'github'
    expect(response).to redirect_to 'back_path'
  end

  it 'calls #unlink from youtube' do
    controller.stub_chain(:current_user, :authentications, :find).and_return(double(User))
    expect(controller).to receive(:unlink_from_youtube)
    get :destroy, id: '1', youtube: true
  end

  it '#unlink_from_youtube' do
    user = stub_model(User, youtube_id: '12345')
    controller.stub(current_user: user)

    get :destroy, id: '1', youtube: true, origin: 'back_path'
    expect(user.youtube_id).to be_nil
    expect(response).to redirect_to 'back_path'
  end
end

