# frozen_string_literal: true

module Helpers
  def default_test_author
    @default_test_author ||= User.find_by_email(default_test_user_details[:email])
    @default_test_author = create(:user, default_test_user_details) if @default_test_author.nil?
    @default_test_author
  end

  def test_ip_address
    '127.0.0.1'
  end

  def test_user_password
    '12345678'
  end

  def default_test_user_details
    {
      first_name: 'Tester',
      last_name: 'Person',
      email: 'testuser@agileventures.org',
      last_sign_in_ip: test_ip_address,
      password: test_user_password,
      password_confirmation: test_user_password,
      display_profile: true,
      latitude: 59.33,
      longitude: 18.06,
      country_name: 'Stockholm',
      bio: 'Full time Tester',
      skill_list: 'Test'
    }
  end

  def create_visitor(receive_mailings: false)
    @visitor ||= { first_name: 'Anders',
                   last_name: 'Persson',
                   email: 'example@example.com',
                   password: 'changemesomeday',
                   password_confirmation: 'changemesomeday',
                   slug: 'slug-ma',
                   country_name: 'Sweden',
                   receive_mailings: receive_mailings }
  end

  def create_user(opts = {})
    @user ||= create(:user, create_visitor.merge(opts))
    @current_user = @user
  end

  def create_privileged_visitor(receive_mailings: false)
    @visitor ||= { first_name: 'Admin',
                   last_name: 'Privilege',
                   email: 'admin@privileged.com',
                   password: 'changemesomeday',
                   password_confirmation: 'changemesomeday',
                   slug: 'slug-admin',
                   country_name: 'UK',
                   receive_mailings: receive_mailings }
  end

  def create_privileged_user
    @user ||= create(:user, create_privileged_visitor)
    @current_user = @user
  end

  def delete_user
    @user&.destroy
    @user = nil
    @current_user = nil
  end

  def sign_up
    delete_user
    visit new_user_registration_path
    within('#main') do
      fill_in 'user_email', with: @visitor[:email]
      fill_in 'user_password', with: @visitor[:password]
      fill_in 'user_password_confirmation', with: @visitor[:password_confirmation]
      find(:css, '#user_receive_mailings').set(@visitor[:receive_mailings])
      click_button 'Sign up'
    end
  end

  def sign_in
    visit new_user_session_path unless current_path == new_user_session_path
    within('#main') do
      fill_in 'user_email', with: @visitor[:email]
      fill_in 'user_password', with: @visitor[:password]
      click_button 'Sign in'
    end
  end

  def all_users
    @all_users = User.all
  end
end

module WithinHelpers
  def with_scope(locator, &block)
    locator ? within(*selector_for(locator), &block) : yield
  end

  def has_link_or_button?(page, name)
    page.has_link?(name) || page.has_button?(name)
  end
end

module WaitForAjax
  def wait_for_ajax
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  end
end

World(Helpers)
World(WithinHelpers)
World(WaitForAjax)

class Capybara::Result
  def second
    self[1]
  end
end

module Capybara
  class Session
    def has_link_or_button?(name)
      has_link?(name) || has_button?(name)
    end
  end
end

class String
  def underscore
    gsub(/::/, '/')
      .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
      .gsub(/([a-z\d])([A-Z])/, '\1_\2')
      .tr('- ', '_')
      .downcase
  end
end
