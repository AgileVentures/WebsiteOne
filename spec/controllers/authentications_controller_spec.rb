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

    request.env['omniauth.auth'] = OmniAuth.config.mock_auth[@provider]
    request.env['omniauth.origin'] = @path
    request.env['omniauth.params'] = {}

    @omniauth = request.env['omniauth.auth']
  end

  describe '#create' do

    context 'auth provider account is registered with a user in our db' do
      before(:each) do
        Authentication.stub(find_by_provider_and_uid: 'authentication')
      end

      it 'attempts to login' do
        controller.stub :attempt_login_with_auth do # substitute implementaion
          controller.redirect_to root_path
        end

        expect(controller).to receive(:attempt_login_with_auth).with('authentication', '/some/path')

        get :create, provider: @provider
      end
    end

    context 'auth provider account is not registered with a user in our db' do

      before(:each) do
        Authentication.stub find_by_provider_and_uid: nil
      end

      it 'connects the auth provider account to user account in our db if user is logged in' do
        controller.stub current_user: 'user'

        controller.stub :create_new_authentication_for_current_user do # substitute implementaion
          controller.redirect_to root_path
        end

        expect(controller).to receive(:create_new_authentication_for_current_user).with(@omniauth, @path)

        get :create, provider: @provider
      end

      it 'creates a new user account and connects auth provider account to it if user is not logged in' do
        controller.stub current_user: nil

        controller.stub :create_new_user_with_authentication do # substitute implementaion
          controller.redirect_to root_path
        end

        expect(controller).to receive(:create_new_user_with_authentication).with(@omniauth)

        get :create, provider: @provider
      end
    end

    it 'sets return path to root_path if auth provider does not set it' do
      request.env['omniauth.origin'] = nil
      get :create, provider: @provider
      expect(assigns(:path)).to eq root_path
    end

  end

  describe '#create_new_user_with_authentication' do
    before(:each) do
      @user = double('User', apply_omniauth: true, save: false)
      User.stub new: @user
      controller.stub(:redirect_to)
    end

    it 'creates a new user and registers the auth provider account' do
      expect(@user).to receive(:apply_omniauth).with(@omniauth)
      controller.send(:create_new_user_with_authentication,@omniauth)
    end

    it 'signs in new user on successful creation' do
      @user.stub save: true
      Mailer.stub(:send_welcome_message).and_return(double('null_object').as_null_object)
      controller.stub :sign_in_and_redirect

      expect(controller).to receive(:sign_in_and_redirect).with(:user, @user)

      controller.send(:create_new_user_with_authentication,@omniauth)
    end


    it 'sends welcome message and sets flash notice on successful creation' do
      @user.stub save: true
      message = double('message', deliver: true)
      Mailer.stub(send_welcome_message: message)
      controller.stub :sign_in_and_redirect

      expect(Mailer).to receive(:send_welcome_message).with(@user)
      expect(message).to receive(:deliver)

      controller.send(:create_new_user_with_authentication,@omniauth)

      expect(flash[:notice]).to eq 'Signed in successfully.'
    end

    it 'redirects to new user registation form on unsuccessful creation' do
      controller.stub :new_user_registration_url
      expect(controller).to receive :new_user_registration_url
      #TODO add session[:omniauth]
      controller.send(:create_new_user_with_authentication,@omniauth)

    end
  end
end
