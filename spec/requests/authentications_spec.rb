require 'spec_helper'

describe 'OmniAuth authentication' do
  before do
    OmniAuth.config.mock_auth[:github] = {
        'provider' => 'github',
        'uid' => '12345678',
        'info' => {
            'email' => 'mock@email.com'
        },
        credentials: {
            token: 'some_token',
            secret: 'some_secret'
        }
    }
    OmniAuth.config.mock_auth[:gplus] = {
        'provider' => 'gplus',
        'uid' => '12345678',
        'info' => {
            'email' => 'mock@email.com'
        },
        credentials: {
            token: 'some_token',
            secret: 'some_secret'
        }
    }
  end

  context 'using Github authentication for unregistered users' do
    it 'should work with valid credentials' do
      visit new_user_session_path
      page.should have_content('Connect with GitHub')
      click_link 'Connect with GitHub'
      page.should have_content('Signed in successfully.')
    end

    it 'should not work with invalid credentials' do
      OmniAuth.config.mock_auth[:github] = :invalid_credentials
      visit new_user_session_path
      page.should have_content('Connect with GitHub')
      click_link 'Connect with GitHub'
      page.should have_content('Authentication failed.')
    end
  end

  context 'using Google+ authentication for unregistered users' do
    it 'should work with valid credentials' do
      visit new_user_session_path
      page.should have_content('Connect with Google+')
      click_link 'Connect with Google+'
      page.should have_content('Signed in successfully.')
    end

    it 'should not work with invalid credentials' do
      OmniAuth.config.mock_auth[:gplus] = :invalid_credentials
      visit new_user_session_path
      page.should have_content('Connect with Google+')
      click_link 'Connect with Google+'
      page.should have_content('Authentication failed.')
    end
  end

  context 'for registered users' do
    before do
      @user = User.create!(email: 'something_else@email.com', password: '123456789')
    end

    context 'using Github' do
      it 'find the right user' do
        @user.authentications.create!(provider: 'github', uid: '12345678')
        visit new_user_session_path
        page.should have_content('Connect with GitHub')
        expect { expect {
          click_link 'Connect with GitHub'
        }.to change(User, :count).by(0) }.to change(Authentication, :count).by(0)
        page.should have_content('Signed in successfully.')
      end
    end

    context 'using Google+' do
      it 'find the right user' do
        @user.authentications.create!(provider: 'gplus', uid: '12345678')
        visit new_user_session_path
        page.should have_content('Connect with Google+')
        expect { expect {
          click_link 'Connect with Google+'
        }.to change(User, :count).by(0) }.to change(Authentication, :count).by(0)
        page.should have_content('Signed in successfully.')
      end
    end
  end
end