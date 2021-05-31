# frozen_string_literal: true

RSpec.describe AuthenticationsController do
  before(:each) do
    OmniAuth.config.mock_auth['agileventures'] = {
      'provider' => 'agileventures',
      'uid' => '12345678',
      'info' => { 'email' => 'foo@agileventures.org' }
    }
    @provider = 'agileventures'
    @path = '/some/path'
    request.env['omniauth.origin'] = @path
  end

  it 'should render a failure message on unsuccessful authentication' do
    get :failure
    expect(flash[:alert]).to eq 'Authentication failed.'
    expect(response).to redirect_to root_path
  end

  context 'destroying authentications' do
    before(:each) do
      @user = double(User, id: 1, friendly_id: 'my-id', encrypted_password: 'i-am-encrypted')
      request.env['warden'].stub authenticate!: @user
      controller.stub current_user: @user

      @auth = double(Authentication)
      @auths = [@auth]
      expect(@user).to receive(:authentications).at_least(1).and_return @auths
      expect(@auths).to receive(:find).and_return @auth
      @auth.stub(destroy: true)
    end

    it 'should require authentication' do
      User.stub(find: @user)
      expect(controller).to receive(:authenticate_user!)
      expect(@user).to receive(:update)
      get :destroy, params: { id: 1 }
    end

    it 'should be removable for users with a password' do
      User.stub(find: @user)
      expect(@auths).to receive(:count).and_return 2
      expect(@auth).to receive(:destroy).and_return true
      expect(@user).to receive(:update).and_return true
      get :destroy, params: { id: 1 }
      expect(flash[:notice]).to eq 'Successfully removed profile.'
    end

    it 'should not be allowed for users without any other means of authentication' do
      expect(@auths).to receive(:count).and_return 1
      expect(@user).to receive(:encrypted_password).and_return nil
      get :destroy, params: { id: 1 }
      expect(flash[:alert]).to eq 'Failed to unlink GitHub. Please use another provider for login or reset password.'
    end
  end

  before(:each) do
    request.env['omniauth.auth'] = OmniAuth.config.mock_auth[@provider]
    request.env['omniauth.params'] = {}
  end

  context 'for not signed in users' do
    before(:each) do
      @user = double(User)
      @user.stub(:apply_omniauth)
    end

    it 'should sign in the correct user for existing profiles' do
      @auth = double(Authentication, user: @user)
      expect(Authentication).to receive(:find_by_provider_and_uid).and_return @auth
      expect(controller).to receive(:sign_in_and_redirect) do
        controller.redirect_to root_path
      end
      get :create, params: { provider: @provider }
      expect(flash[:notice]).to eq 'Signed in successfully.'
    end

    context 'for new profiles' do
      before(:each) do
        expect(Authentication).to receive(:find_by_provider_and_uid).and_return nil
        expect(User).to receive(:new).and_return(@user)
      end

      it 'should create a new user for non-existing profiles' do
        Mailer.stub_chain :send_welcome_message, :deliver_now
        expect(@user).to receive(:save).and_return(true)
        expect(controller).to receive(:sign_in_and_redirect) do
          controller.redirect_to root_path
        end
        get :create, params: { provider: @provider }
        expect(flash[:notice]).to eq 'Signed in successfully.'
      end

      it 'should redirect to the new user form if there is an error' do
        expect(@user).to receive(:save).and_return(false)
        get :create, params: { provider: @provider }
        expect(response).to redirect_to new_user_registration_path
      end
    end

    context 'for deactivated users' do
      before(:each) do
        expect(Authentication).to receive(:find_by_provider_and_uid).and_return nil
        expect(controller).to receive(:deactivated_user_with_email).with('foo@agileventures.org').and_return(@user)
      end

      it 'should redirect to root path with deactivated user alert message' do
        get :create, params: { provider: @provider }
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq('User is deactivated.')
      end
    end
  end

  context 'for signed in users' do
    before(:each) do
      @user = double(User, id: 1, friendly_id: 'my-id', encrypted_password: 'i-am-encrypted')
      request.env['warden'].stub authenticate!: @user
      controller.stub current_user: @user
      @auth = double(Authentication, user: @user)
      controller.stub user_signed_in?: true
    end

    it 'should not allow connecting to a profile when the profile already exists under a different user' do
      Authentication.stub(:find_by_provider_and_uid).and_return @auth
      other_user = double(User, id: @user.id + 1)
      controller.stub current_user: other_user
      get :create, params: { provider: @provider }
      expect(flash[:alert]).to eq 'Another account is already associated with these credentials!'
      expect(response).to redirect_to @path
    end

    context 'connecting to a new profile' do
      before(:each) do
        Authentication.stub(:find_by_provider_and_uid).and_return nil
        @user.stub_chain(:authentications, :build).and_return @auth
      end

      it 'should be able to create other profiles' do
        other_auths = %w(Glitter Smoogle HitPub)
        other_auths.each do |p|
          expect(@auth).to receive(:save).and_return true
          get :create, params: { provider: p }
          expect(flash[:notice]).to eq 'Authentication successful.'
          expect(response).to redirect_to @path
        end
      end

      it 'should not accept multiple profiles from the same source' do
        expect(@auth).to receive(:save).and_return false
        get :create, params: { provider: @provider }
        expect(flash[:alert]).to eq 'Unable to create additional profiles.'
        expect(response).to redirect_to @path
      end
    end
  end

  describe 'Github profile link' do
    before(:each) do
      controller.stub(authenticate_user!: true)

      request.env['omniauth.auth'] = {
        'provider' => 'github',
        'info' => { 'urls' => { 'GitHub' => 'http://github.com/test' } }
      }
    end

    it 'links Github profile when authenticate with GitHub' do
      user = stub_model(User, github_profile_url: nil)
      controller.stub(current_user: user)
      User.stub(find: user)
      user.stub(:reload)

      expect(controller).to receive(:link_github_profile).and_call_original
      get :create, params: { provider: 'github' }
      expect(user.github_profile_url).to eq('http://github.com/test')
    end

    it 'unlinks Github profile when Github profile is removed by user' do
      @user = stub_model(User, github_profile_url: 'http://github.com/test', encrypted_password: 'i-am-encrypted')
      controller.stub(current_user: @user)
      @auth = double(Authentication, user: @user)
      @auths = [@auth]

      User.stub(find: @user)
      expect(@user).to receive(:authentications).at_least(1).and_return @auths
      expect(@auths).to receive(:find).and_return @auth

      expect(@auths).to receive(:count).and_return 2
      expect(@auth).to receive(:destroy).and_return true

      expect(controller).to receive(:destroy).and_call_original
      get :destroy, params: { id: @user.id }
      expect(@user.github_profile_url).to be_nil
    end
  end
end
