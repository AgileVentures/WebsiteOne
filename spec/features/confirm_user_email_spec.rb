require 'rails_helper'

describe 'Confirm user email to create account' do
  feature 'Users signs up' do

    setup do
      visit new_user_registration_path
      fill_in 'user_email', with: 'example@example.com'
      fill_in 'user_password', with: 'changemesomeday'
      fill_in 'user_password_confirmation', with: 'changemesomeday'
      click_button 'Sign up'
    end

    scenario 'confirmation email sent on user signup' do
      expect(User.last.email).to eq('example@example.com')

      expect(ActionMailer::Base.deliveries.count).to eq(2)
      expect(ActionMailer::Base.deliveries[0].to).to include('example@example.com')
      expect(ActionMailer::Base.deliveries[0].body.to_s).to include(User.last.confirmation_token)
    end

    scenario 'confirmation_token link confirms account' do
      expect(ActionMailer::Base.deliveries[0].body.to_s).to include(User.last.confirmation_token)
      visit ("/users/confirmation?confirmation_token=#{User.last.confirmation_token}")
      expect(page).to have_content('Your account was successfully confirmed.')
    end


    scenario 'user cannot sign in for session if email unconfirmed' do
      expect(ActionMailer::Base.deliveries[0].body.to_s).to include(User.last.confirmation_token)
      expect(page).to have_content('A message with a confirmation link has been sent to your email address. Please open the link to activate your account.')
      expect(page).to have_content('Signed up successfully.')

      visit new_user_session_path
      fill_in 'user_email', with: 'example@example.com'
      fill_in 'user_password', with: 'changemesomeday'
      click_button 'Sign in'
      expect(page).to have_content('You have to confirm your account before continuing.')
    end

  end
end