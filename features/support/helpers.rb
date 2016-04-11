module Helpers
  def default_test_author
    @default_test_author ||= User.find_by_email(default_test_user_details[:email])
    if @default_test_author.nil?
      @default_test_author = User.create!(default_test_user_details)
    end
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

  def create_visitor
    @visitor ||= { first_name: 'Anders',
                   last_name: 'Persson',
                   email: 'example@example.com',
                   password: 'changemesomeday',
                   password_confirmation: 'changemesomeday',
                   slug: 'slug-ma',
                   country_name: 'Sweden'}
  end

  def create_user
    @user ||= FactoryGirl.create(:user, create_visitor)
    @current_user = @user
  end

  def delete_user
    @user.destroy if @user
    @user = nil
    @current_user = nil
  end

  def sign_up
    delete_user
    visit new_user_registration_path
    within ('#main') do
      fill_in 'user_email', :with => @visitor[:email]
      fill_in 'user_password', :with => @visitor[:password]
      fill_in 'user_password_confirmation', :with => @visitor[:password_confirmation]
      click_button 'Sign up'
    end
  end

  def sign_in
    visit new_user_session_path
    within ('#main') do
      fill_in 'user_email', :with => @visitor[:email]
      fill_in 'user_password', :with => @visitor[:password]
      click_button 'Sign in'
    end
  end

  def all_users
    @all_users = User.all
  end
end

World(Helpers)

class Capybara::Result
  def second
    self[1]
  end
end

