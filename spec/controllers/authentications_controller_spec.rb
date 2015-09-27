require 'spec_helper'

describe AuthenticationsController do

  before(:each) do
    OmniAuth.config.mock_auth['agileventures'] = {
        'provider' => 'agileventures',
        'uid' => '12345678',
        'info' => {'email' => 'foo@agileventures.org'}
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
      request.env['warden'].stub :authenticate! => @user
      controller.stub :current_user => @user

      @auth = double(Authentication)
      @auths = [@auth]
      @user.should_receive(:authentications).at_least(1).and_return @auths
      @auths.should_receive(:find).and_return @auth
      @auth.stub(destroy: true)
    end

    it 'should require authentication' do
      controller.should_receive(:authenticate_user!)
      get :destroy, id: 1
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
      get :destroy, id: 1
      expect(flash[:alert]).to eq 'Bad idea!'
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
      Authentication.should_receive(:find_by_provider_and_uid).and_return @auth
      controller.should_receive(:sign_in_and_redirect) do
        controller.redirect_to root_path
      end
      get :create, provider: @provider
      expect(flash[:notice]).to eq 'Signed in successfully.'
    end

    context 'for new profiles' do
      before(:each) do
        Authentication.should_receive(:find_by_provider_and_uid).and_return nil
        User.should_receive(:new).and_return(@user)
      end

      it 'should create a new user for non-existing profiles' do
        Mailer.stub_chain :send_welcome_message, :deliver
        @user.should_receive(:save).and_return(true)
        controller.should_receive(:sign_in_and_redirect) do
          controller.redirect_to root_path
        end
        get :create, provider: @provider
        expect(flash[:notice]).to eq 'Signed in successfully.'
      end

      it 'should redirect to the new user form if there is an error' do
        @user.should_receive(:save).and_return(false)
        get :create, provider: @provider
        expect(response).to redirect_to new_user_registration_path
      end
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
      expect(response).to redirect_to @path
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
          expect(response).to redirect_to @path
        end
      end

      it 'should not accept multiple profiles from the same source' do
        @auth.should_receive(:save).and_return false
        get :create, provider: @provider
        expect(flash[:alert]).to eq 'Unable to create additional profiles.'
        expect(response).to redirect_to @path
      end
    end
  end

  describe 'youtube authentication' do
    context 'youtube request' do
      before do
        request.env['omniauth.params']['youtube'] = true
        request.env['omniauth.auth']['credentials'] = {}
      end

      context 'user is signed-in' do
        let(:user) { FactoryGirl.create(:user) }
        before do
          allow(controller).to receive(:current_user).and_return(user)
        end

        it 'links to youtube' do
          expect(controller).to receive(:link_to_youtube).and_call_original
          get :create, provider: 'gplus'
        end

        it 'updates users youtube_id if it does not exist' do
          request.env['omniauth.auth']['credentials']['token'] = 'token'
          allow(user).to receive(:youtube_user_name).and_return('test_user_name')
          allow(YoutubeHelper).to receive(:channel_id).and_return('test_id')
          get :create, provider: 'gplus'
          expect(user.youtube_id).to eq('test_id')
        end

        it 'updates users youtube_user_name if it does not exist' do
          request.env['omniauth.auth']['credentials']['token'] = 'token'
          allow(user).to receive(:youtube_id).and_return('test_id')
          allow(YoutubeHelper).to receive(:youtube_user_name).and_return('test_user_name')

          get :create, provider: 'gplus'

          expect(user.youtube_user_name).to eq('test_user_name')
        end
      end

      context 'user is not signed-in' do
        it 'does not link to youtube' do
          allow(controller).to receive(:current_user)
          expect(controller).to_not receive(:link_to_youtube)

          get :create, provider: 'gplus'
        end
      end
    end

    context 'non-youtube request' do
      it 'does not link to youtube' do
        request.env['omniauth.params']['youtube'] = nil

        expect(controller).to_not receive(:link_to_youtube)

        get :create, provider: 'gplus'
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
      get :create, provider: 'github'
      expect(user.github_profile_url).to eq('http://github.com/test')
    end
  end
end
