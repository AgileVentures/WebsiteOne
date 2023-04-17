# frozen_string_literal: true

RSpec.describe 'OmniAuth authentication', type: :feature do
  supported_auths = {
    'github' => 'GitHub',
    'gplus' => 'Google'
  }

  before do
    StaticPage.create!(title: 'getting started', body: 'remote pair programming')
    @uid = '12345678'
    supported_auths.each do |provider, name|
      OmniAuth.config.mock_auth[provider.to_sym] = {
        'provider' => provider,
        'uid' => @uid,
        'info' => { 'email' => "#{name}@mock.com" }
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
          expect(page).to have_content "with #{name}"

          expect do
            expect do
              page.click_on "with #{name}"
            end.to change(User, :count).by(1)
          end.to change(Authentication, :count).by(1)
          expect(page).to have_content('Signed in successfully.')
          expect(User.first.karma).not_to be_nil
        end

        it 'should not work with invalid credentials' do
          OmniAuth.config.mock_auth[provider.to_sym] = :invalid_credentials
          visit new_user_session_path
          expect do
            expect do
              page.click_on "with #{name}"
            end.to change(User, :count).by(0)
          end.to change(Authentication, :count).by(0)
          expect(page).to have_content('invalid_credentials')
        end

        xit 'should not allow removal of profiles without passwords' do
          visit new_user_session_path
          click_link "with #{name}"
          visit edit_user_registration_path
          # click_link '#user_info'
          # click_link 'My Account'
          expect do
            expect do
              click_link "Remove #{name}"
            end.to change(User, :count).by(0)
          end.to change(Authentication, :count).by(0)
          expect(page).to have_content 'Failed to unlink GitHub. Please use another provider for login or reset password.'
        end
      end
    end

    context 'for registered users' do
      before do
        @user = User.create!(email: 'something_else@email.com', password: '123456789')
      end

      context "with a #{name} profile" do
        before do
          @user.authentications.create!(provider: provider, uid: @uid)
        end

        xit 'finds the right user if auth exists' do
          visit new_user_session_path
          expect(page).to have_content "with #{name}"
          expect do
            expect do
              click_link "with #{name}"
            end.to change(User, :count).by(0)
          end.to change(Authentication, :count).by(0)
          expect(page).to have_content('Signed in successfully.')
        end

        xit 'should be removable for users with a password' do
          visit new_user_session_path
          click_link "with #{name}"
          visit edit_user_registration_path(@user)

          expect(page).to have_css "input[value='#{@user.email}']"
          expect do
            expect do
              click_link "Remove #{name}"
            end.to change(User, :count).by(0)
          end.to change(Authentication, :count).by(-1)
          expect(page).to have_content('Successfully removed profile.')
        end

        xit 'should be able to create other profiles' do
          supported_auths.each do |p, n|
            next if p == provider

            visit new_user_session_path
            click_link "with #{name}"
            visit edit_user_registration_path(@user)
            expect do
              expect { click_link n.to_s }.to change(Authentication, :count).by(1)
            end.to change(User, :count).by(0)
          end
        end
      end
    end
  end
end
