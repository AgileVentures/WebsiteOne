require 'spec_helper'

describe 'OmniAuth authentication' do

  supported_auths = {
      'github' => 'GitHub',
      'gplus'  => 'Google+'
  }

  before do
    supported_auths.keys.each do |provider|
      AuthenticationProvider.create(name: provider)
    end
    @uid = '12345678'
    supported_auths.each do |provider, name|
      OmniAuth.config.mock_auth[provider.to_sym] = {
          'provider'  => provider,
          'uid'       => @uid,
          'info'      => { 'email' => "#{name}@mock.com"},
          'credentials' => {}
      }
    end
    OmniAuth.config.logger.level = Logger::FATAL
  end

  after { OmniAuth.config.logger.level = Logger::DEBUG }

  supported_auths.each do |provider, name|
    context 'for unregistered users' do
      context "with a #{name} profile" do
        it 'should work with valid credentials' do
          visit new_user_session_path
          page.should have_content "#{name}"
          expect {
            expect {
              click_link "#{name}"
            }.to change(User, :count).by(1)
          }.to change(UserAuthentication, :count).by(1)
          page.should have_content('Signed in successfully')
        end

        it 'should not work with invalid credentials' do
          OmniAuth.config.mock_auth[provider.to_sym] = :invalid_credentials
          visit new_user_session_path
          expect {
            expect {
              click_link "#{name}"
            }.to change(User, :count).by(0)
          }.to change(UserAuthentication, :count).by(0)
          page.should have_content("Could not authenticate you because \"Invalid credentials\"")
        end

        it 'should not allow removal of profiles without passwords' do
          visit new_user_session_path
          click_link "#{name}"
          visit edit_user_registration_path
          #click_link '#user_info'
          #click_link 'My Account'
          expect {
            expect {
              click_link "Remove #{name}"
            }.to change(User, :count).by(0)
          }.to change(UserAuthentication, :count).by(0)
          page.should have_content 'Bad idea!'
        end
      end
    end

    context 'for registered users' do
      before do
        @user = User.create!(email: 'something_else@email.com', password: '123456789')
      end

      context "with a #{name} profile" do
        before do
          auth_params = OmniAuth.config.mock_auth[provider.to_sym]
          provider_obj = AuthenticationProvider.where(name: auth_params['provider']).first
          UserAuthentication.create_from_omniauth(auth_params, @user, provider_obj)
        end

        it 'finds the right user if auth exists' do
          visit new_user_session_path
          page.should have_content "#{name}"
          expect {
            expect {
              click_link "#{name}"
            }.to change(User, :count).by(0)
          }.to change(UserAuthentication, :count).by(0)
          page.should have_content('Signed in successfully.')
        end

        it 'should be removable for users with a password' do
          visit new_user_session_path
          click_link "#{name}"
          visit edit_user_registration_path(@user)
          page.should have_css "input[value='#{@user.email}']"
          expect {
            expect {
              click_link "Remove #{name}"
            }.to change(User, :count).by(0)
          }.to change(UserAuthentication, :count).by(-1)
          page.should have_content('Successfully removed profile.')
        end

        it 'should be able to create other profiles' do
          supported_auths.each do |p, n|
            next if p == provider
            visit new_user_session_path
            click_link "#{name}"
            visit edit_user_registration_path(@user)
            expect {
              expect { click_link "#{n}" }.to change(UserAuthentication, :count).by(1)
            }.to change(User, :count).by(0)
          end
        end

        it 'should not accept multiple profiles from the same source' do
          visit new_user_session_path
          click_link "#{name}"
          OmniAuth.config.mock_auth[provider.to_sym] = {
              'provider'  => provider,
              'uid'       => "randomplus#{@uid}"
          }
          visit "/users/auth/#{provider}"
          page.should have_content 'Unable to create additional profiles.'
        end
      end
    end
  end
end
